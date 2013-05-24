//
//  SpeechManager.m
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "SpeechManager.h"
#import "SpeechManager+Parser.h"
#import "SpeechManager+Recognition.h"
#import "Word.h"


NSString *const SpeechManagerDidUpdateNotification = @"SpeechManagerDidUpdateNotification";

@implementation SpeechManager

- (id)init {
    self = [super init];
    
    if (self) {
        self.contact = @"";
        self.contactSuggestionArray = [[NSMutableArray alloc] initWithCapacity:1];
        self.command = [[Command alloc] initWithCommand:@"" ofType:CommandTypeIgnore];
    }
    
    return self;
}


#pragma mark -
#pragma mark Accessor Methods

- (FliteController *)fliteController {
	if (!_fliteController) {
		_fliteController = [[FliteController alloc] init];
	}
	return _fliteController;
}

- (LanguageModel *)languageModel {
	if (!_languageModel) {
		_languageModel = [[LanguageModel alloc] init];
	}
	return _languageModel;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (!_openEarsEventsObserver) {
		_openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return _openEarsEventsObserver;
}

- (PocketsphinxController *)pocketsphinxController {
	if (!_pocketsphinxController) {
		_pocketsphinxController = [[PocketsphinxController alloc] init];
        _pocketsphinxController.secondsOfSilenceToDetect = 0.5;
        _pocketsphinxController.returnNullHypotheses = YES;
	}
	return _pocketsphinxController;
}

- (void)setState:(SpeechManagerState)state {
    _state = state;
    [[NSNotificationCenter defaultCenter] postNotificationName:SpeechManagerDidUpdateNotification
                                                        object:self];
}


#pragma mark - 
#pragma mark Private Methods

- (void)checkAvailability:(NSString *)contact withCompletionBlock:(void (^)(BOOL isAvailable))block {
    NSLog(@"-- checkAvailability: -- ");
    NSLog(@"Contact: %@", contact);
    
    self.state = SMStateCheckingAvailability;
    
    BOOL available = NO;
    int rand = arc4random() % 2;
    
    if (rand) {
        available = YES;
    }
    
    // Simulate delay for checking.
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (block) {
            block(available);
        }
    });
}

- (void)commandNotFound {
    NSLog(@"-- commandNotFound --");
}

- (void)connectToContact:(NSString *)contact {
    NSLog(@"-- connectToContact --");
    
    // Simulate delay for connecting.
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[SpeechManager shared] setState:SMStateConnected];
    });
}

- (void)contactNotFound {
    NSLog(@"-- contactNotFound --");
}

- (void)playMessage {
    NSLog(@"-- playMessage --");
}

- (void)sendMessage:(NSString *)contact {
    NSLog(@"-- sendMessage --");
    
    // Simulate delay for preparing to record.
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[SpeechManager shared] setState:SMStateRecordMessage];
    });
}

- (BOOL)verifyContact:(NSString *)contact {
    NSLog(@" -- verifyContact: --");
    NSLog(@"Contact: %@", contact);
    
    BOOL verified = NO;
    
    [self.contactSuggestionArray removeAllObjects];
    
    if ([self.languageModel.contactStringArray containsObject:contact]) {
        NSLog(@"Contact verified.");
        verified = YES;
    }
    else {
        for (NSString *string in self.languageModel.contactStringArray) {
            NSArray *array = [string componentsSeparatedByString:@" "];
            if ([array containsObject:contact]) {
                NSLog(@"Partial contact verified");
                [self.contactSuggestionArray addObject:string];
            }
        }
        
        if ([self.contactSuggestionArray count] == 0) {
            [self contactNotFound];
        }
        else if ([self.contactSuggestionArray count] == 1) {
            self.contact = [self.contactSuggestionArray objectAtIndex:0];
            verified = YES;
        }
        else if ([self.contactSuggestionArray count] > 1) {
            self.state = SMStateContactRequest;
        }
    }

    return verified;
}


#pragma mark -
#pragma mark Class Methods

+ (SpeechManager *)shared {
    static SpeechManager *speechManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        speechManager = [[SpeechManager alloc] init];
    });
    
    return speechManager;
}


#pragma mark -
#pragma mark Instance Methods

- (void)performCommand:(NSString *)commandString withContact:(NSString *)contactString {
    NSLog(@"-- performCommand: withContact: --");
    NSLog(@"commandString: %@; contactString: %@", commandString, contactString);
    
    // How I am handling updating the command and contact seems confusing and
    // difficult to maintain if states are added or removed.
    // Better way to handle this???
    // Also look into when to clear the stored command and contact.
    
    // Only update the command string if there is a command
    // and we are in a state that is expecting a command.
    if ([commandString length] > 0 &&
        (self.state == SMStateConnectRequest ||
         self.state == SMStateFindContactRequest ||
         self.state == SMStateMain ||
         self.state == SMStateSendMessageRequest)) {
        self.command = [self.languageModel.commandObjectDict objectForKey:commandString];
    }
    
    // Only update the contact if there is a contact
    // and we are in a state that is expecting a contact.
    if ([contactString length] > 0 &&
        (self.state == SMStateContactRequest ||
         self.state == SMStateMain)) {
        self.contact = contactString;
    }
    
    NSLog(@"Current state: %d", self.state);
    NSLog(@"Command: %@; Contact: %@", self.command.value, self.contact);
    
    switch (self.command.type) {
        //----------------------------------------------------------------------------
        case CommandTypeIgnore:
            break;
        //----------------------------------------------------------------------------
        case CommandTypeAffirmative:
            if (self.state == SMStateConnectRequest) {
                if ([self verifyContact:self.contact]) {
                    [self connectToContact:self.contact];
                    self.state = SMStateConnecting;
                    self.contact = @"";
                }
            }
            else if (self.state == SMStateFindContactRequest) {
                self.state = SMStateMain;
                self.contact = @"";
            }
            else if (self.state == SMStateSendMessageRequest) {
                if ([self verifyContact:self.contact]) {
                    [self sendMessage:self.contact];
                    self.state = SMStatePreparingToRecord;
                    self.contact = @"";
                }
            }
            break;
        //----------------------------------------------------------------------------
        case CommandTypeAvailable:
            if (self.state == SMStateContactRequest ||
                self.state == SMStateMain) {
                if ([self verifyContact:self.contact]) {
                    __weak SpeechManager *weakSelf = self;
                    [self checkAvailability:self.contact withCompletionBlock:^(BOOL isAvailable) {
                        if (isAvailable) {
                            weakSelf.state = SMStateConnectRequest;
                        }
                        else {
                            weakSelf.state = SMStateSendMessageRequest;
                        }
                    }];
                }
            }
            break;
        //----------------------------------------------------------------------------
        case CommandTypeConnectTo:
            if (self.state == SMStateContactRequest ||
                self.state == SMStateMain) {
                if ([self verifyContact:self.contact]) {
                    __weak SpeechManager *weakSelf = self;
                    [self checkAvailability:self.contact withCompletionBlock:^(BOOL isAvailable) {
                        if (isAvailable) {
                            [self connectToContact:self.contact];
                            weakSelf.state = SMStateConnecting;
                            self.contact =@"";
                        }
                        else {
                            weakSelf.state = SMStateSendMessageRequest;
                        }
                    }];
                }
            }
            break;
        //----------------------------------------------------------------------------
        case CommandTypeNegative:
            if (self.state == SMStateConnectRequest) {
                self.state = SMStateFindContactRequest;
                self.contact =@"";
            }
            else if (self.state == SMStateFindContactRequest) {
                self.state = SMStateIdle;
                self.contact =@"";
            }
            else if (self.state == SMStateSendMessageRequest) {
                self.state = SMStateFindContactRequest;
                self.contact =@"";
            }
            break;
        //----------------------------------------------------------------------------
        case CommandTypePlayMessage:
            [self playMessage];
            self.state = SMStateRecentMessage;
            break;
        //----------------------------------------------------------------------------
        case CommandTypeSendMessageTo:
            if ([self verifyContact:self.contact]) {
                [self sendMessage:self.contact];
                self.state = SMStatePreparingToRecord;
                self.contact =@"";
            }
            break;
        //----------------------------------------------------------------------------
        default:
            [self commandNotFound];
            break;
    }
}

#pragma mark -
#pragma mark OpenEarsEventsObserverDelegate Methods

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis
                         recognitionScore:(NSString *)recognitionScore
                              utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    
    self.hypothesis = hypothesis;
    [self parseSpeechHypothesis:hypothesis];
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
    self.state = SMStateNotReady;
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
    self.state = SMStateReady;
    [self suspendSpeechRecognition];
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString
                                    andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}

- (void) fliteDidStartSpeaking {
    NSLog(@"Flite Controller did start speaking..");
}

- (void) fliteDidFinishSpeaking {
    NSLog(@"Flite Controller did stop speaking..");
}

@end
