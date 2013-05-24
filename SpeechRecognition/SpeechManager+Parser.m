//
//  SpeechManager+Parser.m
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "SpeechManager+Parser.h"
#import "Word.h"

@implementation SpeechManager (Parser)

- (void)parseSpeechHypothesis:(NSString *)speech {
//    NSLog(@"About to parse the following speech:");
//    NSLog(@"%@", speech);
    
    if ([speech length] > 0) {
        NSArray *speechArray = [speech componentsSeparatedByString:@" "];
        NSString *contact = @"";
        NSString *command = @"";
        BOOL firstCommand = YES;
        BOOL firstContact = YES;
        
        for (NSString *string in speechArray) {
            Word *word = [self.languageModel.wordObjectDict objectForKey:string];
            
            if (word.type == WordTypeCommand) {
                if(!firstCommand) command = [command stringByAppendingString:@" "];
                command = [command stringByAppendingString:word.value];
                firstCommand = NO;
            }
            else if (word.type == WordTypeContact){
                if(!firstContact) contact = [contact stringByAppendingString:@" "];
                contact = [contact stringByAppendingString:word.value];
                firstContact = NO;
            }
        }
        
        [self performCommand:command withContact:contact];
    }
    else
    {
        NSLog(@"Nothing to parse; hypothesis speech string was empty...");
    }
}

@end
