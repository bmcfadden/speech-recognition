//
//  ViewController.m
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "ViewController.h"
#import "SpeechManager.h"
#import "SpeechManager+Recognition.h"
#import "Word.h"

NSString *const SMPromptCheckingAvailability = @"Checking availability...";
NSString *const SMPromptConnected =@"Connected to another Perchlet!";
NSString *const SMPromptConnecting = @"Connecting...";
NSString *const SMPromptConnectRequest = @"Yes they are! Would you like to connect with them?\n\n\nCommands:\n\nYes please!\nNo thank you!";
NSString *const SMPromptContactRequest = @"There are multiple contacts with that name. Please specify which contact you would like.";
NSString *const SMPromptFindContactRequest = @"Okay, can I help you find someone else?\n\n\nCommands:\n\nYes please!\nNo thank you!";
NSString *const SMPromptIdle = @"";
NSString *const SMPromptMain = @"Hi There!\nWhat would you like to do today?\n\n\nCommands:\n\nIs [name] Available.\nConnect With [name].\nSend [name] A Message.\nPlay Next Message.";
NSString *const SMPromptNotReady = @"Loading...";
NSString *const SMPromptPreparingToRecord = @"Preparing to record...";
NSString *const SMPromptReady = @"Ready to rock!";
NSString *const SMPromptRecordMessage = @"Recording message.";
NSString *const SMPromptRecentMessage = @"Here is your most recent message.";
NSString *const SMPromptSendMessageRequest = @"I'm afraid they are unavailable. Would you like to send them a message?\n\n\nCommands:\n\nYes please!\nNo thank you!";

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[SpeechManager shared] openEarsEventsObserver] setDelegate:[SpeechManager shared]];
    [[SpeechManager shared] startSpeechRecognitionEngine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViews)
                                                 name:SpeechManagerDidUpdateNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swipeGestureLeft:(id)sender {
    NSLog(@"swipeGestureLeft");

    [[SpeechManager shared] resumeSpeechRecognition];
    //[[SpeechManager shared] setCurrentPrompt:SMPromptMain];
    [[SpeechManager shared] setState:SMStateMain];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.speechPromptTextView.backgroundColor = [UIColor darkGrayColor];
    }];
    
    self.speechStatusLabel.textColor = [UIColor whiteColor];
    self.speechPromptTextView.textColor = [UIColor whiteColor];
    self.recognizedSpeechLabel.textColor = [UIColor whiteColor];
}

- (IBAction)swipeGestureRight:(id)sender {
    NSLog(@"swipeGestureRight");
    
    [[SpeechManager shared] suspendSpeechRecognition];
    
    if (![self.speechPromptTextView.text isEqualToString:SMPromptConnected] &&
        ![self.speechPromptTextView.text isEqualToString:SMPromptRecentMessage] &&
        ![self.speechPromptTextView.text isEqualToString:SMPromptRecordMessage]) {
        self.speechPromptTextView.text = SMPromptIdle;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.speechPromptTextView.backgroundColor = [UIColor whiteColor];
    }];
    
    self.speechStatusLabel.textColor = [UIColor blackColor];
    self.speechPromptTextView.textColor = [UIColor blackColor];
    self.recognizedSpeechLabel.textColor = [UIColor blackColor];
}

- (void)updateViews {
    NSLog(@"updateViews; state: %d", [[SpeechManager shared] state]);
    
    self.recognizedSpeechLabel.text = [[SpeechManager shared] hypothesis];

    NSString *contactString = @"";
    if ([[SpeechManager shared] state] == SMStateContactRequest) {
        for (NSString *contact in [[SpeechManager shared] contactSuggestionArray]) {
            contactString = [contactString stringByAppendingFormat:@"\n%@", contact];
        }
    }
    
    switch ([[SpeechManager shared] state]) {
        case  SMStateCheckingAvailability:
            self.speechPromptTextView.text = SMPromptCheckingAvailability;
            break;
            
        case  SMStateConnected:
            [self swipeGestureRight:self];
            self.speechPromptTextView.text = SMPromptConnected;
            break;
            
        case  SMStateConnecting:
            self.speechPromptTextView.text = SMPromptConnecting;
            break;
            
        case  SMStateConnectRequest:
            self.speechPromptTextView.text = SMPromptConnectRequest;
            break;
            
        case SMStateContactRequest:
            self.speechPromptTextView.text = [SMPromptContactRequest stringByAppendingFormat:@"\n%@", contactString];
            break;
            
        case  SMStateFindContactRequest:
            self.speechPromptTextView.text = SMPromptFindContactRequest;
            break;
            
        case  SMStateIdle:
            [self swipeGestureRight:self];
            break;
            
        case  SMStateMain:
            self.speechPromptTextView.text = SMPromptMain;
            break;
            
        case  SMStateNotReady:
            self.speechPromptTextView.text = SMPromptNotReady;
            break;
            
        case  SMStatePreparingToRecord:
            self.speechPromptTextView.text = SMPromptPreparingToRecord;
            break;
            
        case  SMStateReady:
            self.speechPromptTextView.text = SMPromptReady;
            break;
            
        case  SMStateRecentMessage:
            [self swipeGestureRight:self];
            self.speechPromptTextView.text = SMPromptRecentMessage;
            break;
            
        case  SMStateRecordMessage:
            [self swipeGestureRight:self];
            self.speechPromptTextView.text = SMPromptRecordMessage;
            break;
            
        case  SMStateSendMessageRequest:
            self.speechPromptTextView.text = SMPromptSendMessageRequest;
            break;
            
        default:
            break;
    }
    
}

@end
