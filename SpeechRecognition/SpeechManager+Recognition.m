//
//  SpeechManager+Recognition.m
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "SpeechManager+Recognition.h"

@implementation SpeechManager (Recognition)

#pragma mark -
#pragma mark Instance Methods

- (void)startSpeechRecognitionEngine {
    if (!self.languageModel.lmPath || !self.languageModel.dictPath) {
        [self.languageModel generateLanguageModel];
    }
    
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.languageModel.lmPath
                                                      dictionaryAtPath:self.languageModel.dictPath
                                                   languageModelIsJSGF:NO];
}

- (void)stopSpeechRecognitionEngine {
    [self.pocketsphinxController stopListening];
}

- (void)suspendSpeechRecognition {
    [self.pocketsphinxController suspendRecognition];
}

- (void)resumeSpeechRecognition {
    NSLog(@"resumeSpeechRecognition");
    [self.pocketsphinxController resumeRecognition];
}

@end
