//
//  LanguageModel.m
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "LanguageModel.h"
#import <OpenEars/LanguageModelGenerator.h>

NSString *const SpeechCatCmdAffirmative = @"SpeechCatCmdAffirmative";
NSString *const SpeechCatCmdAvailable = @"SpeechCatCmdAvailable";
NSString *const SpeechCatCmdConnect = @"SpeechCatCmdConnect";
NSString *const SpeechCatCmdNegative = @"SpeechCatCmdNegative";
NSString *const SpeechCatCmdPlay = @"SpeechCatCmdPlay";
NSString *const SpeechCatCmdSend = @"SpeechCatCmdSend";
NSString *const SpeechCatContact = @"SpeechCatContact";
NSString *const SpeechCatIgnore = @"SpeechCatIgnore";

@implementation LanguageModel

#pragma mark -
#pragma mark Private Methods

- (void)generateCommandDictionary {
    self.commandDict = nil;
    self.commandDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                        SpeechCatCmdAffirmative, @"YEP",
                        SpeechCatCmdAffirmative, @"YES",
                        SpeechCatCmdAvailable, @"AVAILABLE",
                        SpeechCatCmdAvailable, @"AROUND",
                        SpeechCatCmdAvailable, @"ONLINE",
                        SpeechCatCmdAvailable, @"THERE",
                        SpeechCatCmdConnect, @"CONNECT",
                        SpeechCatCmdNegative, @"NO",
                        SpeechCatCmdNegative, @"NOPE",
                        SpeechCatCmdPlay, @"PLAY",
                        SpeechCatCmdSend, @"SEND",
                        nil];
}

- (void)generateCompleteDictionary {
    self.completeDict = nil;
    self.completeDict = [[NSMutableDictionary alloc] init];
    
    [self generateCommandDictionary];
    [self generateContactDictionary];
    [self generateSupportDictionary];
    
    [self.completeDict addEntriesFromDictionary:self.commandDict];
    [self.completeDict addEntriesFromDictionary:self.contactDict];
    [self.completeDict addEntriesFromDictionary:self.supportDict];
}

- (void)generateContactDictionary {
    self.contactDict = nil;
    self.contactArray = nil;
    self.contactArray = [NSArray arrayWithObjects:
                         @"ADAM STANTON",
                         @"BRIAN MCFADDEN",
                         @"DANNY ROBINSON",
                         @"IAN WALKER",
                         @"LANCE FU",
                         @"PAT DRYBURGH",
                         @"STEVE MCKENZIE",
                         @"BOSTON DESIGN TEAM",
                         @"DANS PERCH PAD",
                         @"PERCH DESK",
                         @"WALKA PAD",
                         @"SAN FRANCISCO DESIGN TEAM",
                         nil];
    
    // Separate the contact array into an array of single words.
    NSMutableArray *tempContactArray = [[NSMutableArray alloc] init];
    
    for (NSString *contact in self.contactArray) {
        NSArray *items = [contact componentsSeparatedByString:@" "];
        [tempContactArray addObjectsFromArray:items];
    }
    
    NSMutableArray *speechCatArray = [[NSMutableArray alloc] init];
    
    for (NSString *contact in tempContactArray) {
        [speechCatArray addObject:SpeechCatContact];
    }
    
    self.contactDict = [[NSDictionary alloc] initWithObjects:speechCatArray forKeys:tempContactArray];
}

- (void)generateSupportDictionary {
    self.supportDict = nil;
    self.supportDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                        SpeechCatIgnore, @"A",
                        SpeechCatIgnore, @"IS",
                        SpeechCatIgnore, @"MESSAGE",
                        SpeechCatIgnore, @"NEXT",
                        SpeechCatIgnore, @"THE",
                        SpeechCatIgnore, @"TO",
                        nil];
}

#pragma mark -
#pragma mark Instance Methods

- (void)generateLanguageModel {    
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    NSString *filename = @"LanguageModel";
    
    [self generateCompleteDictionary];
    
    NSMutableArray *languageArray = [[NSMutableArray alloc] init];
    [languageArray addObjectsFromArray:[self.completeDict allKeys]];
    
//    for(NSString *key in self.commandDict)
//        NSLog(@"key=%@ value=%@", key, [self.commandDict objectForKey:key]);
//    
//    for(NSString *key in self.contactDict)
//        NSLog(@"key=%@ value=%@", key, [self.contactDict objectForKey:key]);
//    
//    for(NSString *key in self.supportDict)
//        NSLog(@"key=%@ value=%@", key, [self.supportDict objectForKey:key]);
//    
//    for (NSString *word in languageArray)
//        NSLog(@"%@", word);
    
    NSError *err = [lmGenerator generateLanguageModelFromArray:languageArray withFilesNamed:filename];
    
    self.lmGeneratorResults = nil;
    self.lmPath = nil;
    self.dicPath = nil;
    
    if([err code] == noErr) {
        self.lmGeneratorResults = [err userInfo];
        self.lmPath = [self.lmGeneratorResults objectForKey:@"LMPath"];
        self.dicPath = [self.lmGeneratorResults objectForKey:@"DictionaryPath"];
    }
    else {
        NSLog(@"Error: %@",[err localizedDescription]);
        
        // TODO: Handle the error.
    }
}

@end
