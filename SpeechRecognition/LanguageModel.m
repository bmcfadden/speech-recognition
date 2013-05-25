//
//  LanguageModel.m
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-15.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "LanguageModel.h"
#import <OpenEars/LanguageModelGenerator.h>
#import "Command.h"
#import "Word.h"

@interface LanguageModel ()

@property (nonatomic, strong) NSMutableArray *perchletStringArray;
@property (nonatomic, strong) NSMutableArray *personStringArray;
@property (nonatomic, strong) NSMutableArray *supportStringArray;

@end

@implementation LanguageModel

- (id)init {
    self = [super init];
    
    if (self) {
        self.commandStringArray = [NSMutableArray arrayWithCapacity:1];
        self.contactStringArray = [NSMutableArray arrayWithCapacity:1];
        self.perchletStringArray = [NSMutableArray arrayWithCapacity:1];
        self.personStringArray = [NSMutableArray arrayWithCapacity:1];
        self.supportStringArray = [NSMutableArray arrayWithCapacity:1];
        self.commandObjectDict = [NSMutableDictionary dictionaryWithCapacity:1];
        self.wordObjectDict = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    return self;
}


#pragma mark -
#pragma mark Private Methods

- (void)generateCommandObjectDictionary {
    [self.commandObjectDict removeAllObjects];
    NSArray *commandObjectArray = [NSArray arrayWithObjects:
                                   [[Command alloc] initWithCommand:@"YES PLEASE" ofType:CommandTypeAffirmative],
                                   [[Command alloc] initWithCommand:@"AROUND" ofType:CommandTypeAvailable],
                                   [[Command alloc] initWithCommand:@"AVAILABLE" ofType:CommandTypeAvailable],
                                   [[Command alloc] initWithCommand:@"ONLINE" ofType:CommandTypeAvailable],
                                   [[Command alloc] initWithCommand:@"CONNECT WITH" ofType:CommandTypeConnectTo],
                                   [[Command alloc] initWithCommand:@"NO THANK YOU" ofType:CommandTypeNegative],
                                   [[Command alloc] initWithCommand:@"PLAY NEXT MESSAGE" ofType:CommandTypePlayMessage],
                                   [[Command alloc] initWithCommand:@"SEND MESSAGE" ofType:CommandTypeSendMessageTo],
                                   nil];
    
    for (Command *command in commandObjectArray) {
        [self.commandObjectDict setObject:command forKey:command.value];
    }
    
//    NSLog(@"\n\nCommand Object Dictionary:");
//    for (NSString *key in self.commandObjectDict) {
//        Command *command = [self.commandObjectDict objectForKey:key];
//        NSLog(@"Key: %@; Command: %@; Type: %d", key, command.value, command.type);
//    }
}

- (void)generateCommandStringArray {
    [self generateCommandObjectDictionary];
    [self.commandStringArray removeAllObjects];
    
    for (NSString *key in self.commandObjectDict) {
        [self.commandStringArray addObject:key];
    }
}

- (void)generateContactStringArray {
    [self generatePersonStringArray];
    [self generatePerchletStringArray];
    [self.contactStringArray removeAllObjects];
    [self.contactStringArray addObjectsFromArray:self.personStringArray];
    [self.contactStringArray addObjectsFromArray:self.perchletStringArray];
}

- (void)generatePerchletStringArray {
    [self.perchletStringArray removeAllObjects];
    [self.perchletStringArray addObjectsFromArray:[NSArray arrayWithObjects:
                                                   @"BOSTON DESIGN TEAM",
                                                   @"DANS PERCH PAD",
                                                   @"PERCH DESK",
                                                   @"WALKA PAD",
                                                   @"SAN FRANCISCO DESIGN TEAM",
                                                   nil]];
    
}

- (void)generatePersonStringArray {
    [self.personStringArray removeAllObjects];
    [self.personStringArray addObjectsFromArray:[NSArray arrayWithObjects:
                                                 @"ADAM STANTON",
                                                 @"ADAM SANDLER",
                                                 @"BRIAN MCFADDEN",
                                                 @"DANNY DEVITO",
                                                 @"DANNY ROBINSON",
                                                 @"IAN WALKER",
                                                 @"LANCE FU",
                                                 @"PAT DRYBURGH",
                                                 @"ROBINSON CRUSOE",
                                                 @"STEVE MCKENZIE",
                                                 nil]];
}

- (void)generateSupportStringArray {
    [self.supportStringArray removeAllObjects];
    [self.supportStringArray addObjectsFromArray:[NSArray arrayWithObjects:
                                                  @"A",
                                                  @"IS",
                                                  @"MY",
                                                  @"THE",
                                                  @"TO",
                                                  nil]];
}

- (void)generateWordObjectDictionary {
    [self generateCommandStringArray];
    [self generateContactStringArray];
    [self generateSupportStringArray];
    [self.wordObjectDict removeAllObjects];
    
    for (NSString *command in self.commandStringArray) {
        NSArray *stringArray = [command componentsSeparatedByString:@" "];
        for (NSString *string in stringArray) {
            [self.wordObjectDict setObject:[[Word alloc] initWithWord:string ofType:WordTypeCommand] forKey:string];
        }
    }
    
    for (NSString *contact in self.contactStringArray) {
        NSArray *stringArray = [contact componentsSeparatedByString:@" "];
        for (NSString *string in stringArray) {
            [self.wordObjectDict setObject:[[Word alloc] initWithWord:string ofType:WordTypeContact] forKey:string];
        }
    }
    
    for (NSString *support in self.supportStringArray) {
        NSArray *stringArray = [support componentsSeparatedByString:@" "];
        for (NSString *string in stringArray) {
            [self.wordObjectDict setObject:[[Word alloc] initWithWord:string ofType:WordTypeIgnore] forKey:string];
        }
    }
    
//    NSLog(@"\n\nWord Object Dictionary:");
//    for (NSString *key in self.wordObjectDict) {
//        Word *word = [self.wordObjectDict objectForKey:key];
//        NSLog(@"Key: %@; Word: %@; Type: %d", key, word.value, word.type);
//    }
}


#pragma mark -
#pragma mark Instance Methods

- (void)generateLanguageModel {
    [self generateWordObjectDictionary];
    
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    NSString *filename = @"LanguageModel";
    NSMutableArray *languageArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [languageArray addObjectsFromArray:self.commandStringArray];
    [languageArray addObjectsFromArray:self.contactStringArray];
    [languageArray addObjectsFromArray:self.supportStringArray];
    
//    NSLog(@"\n\nLanguage Model Array:");
//    for (NSString *string in languageArray) {
//        NSLog(@"Word: %@", string);
//    }
    
    NSError *err = [lmGenerator generateLanguageModelFromArray:languageArray withFilesNamed:filename];
    
    self.lmGeneratorResults = nil;
    self.lmPath = nil;
    self.dictPath = nil;
    
    if([err code] == noErr) {
        self.lmGeneratorResults = [err userInfo];
        self.lmPath = [self.lmGeneratorResults objectForKey:@"LMPath"];
        self.dictPath = [self.lmGeneratorResults objectForKey:@"DictionaryPath"];
    }
    else {
        NSLog(@"Error: %@",[err localizedDescription]);
        
        // TODO: Handle the error.
    }
}

@end
