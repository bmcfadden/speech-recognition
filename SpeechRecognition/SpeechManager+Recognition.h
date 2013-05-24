//
//  SpeechManager+Recognition.h
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "SpeechManager.h"

@interface SpeechManager (Recognition)

- (void)startSpeechRecognitionEngine;
- (void)stopSpeechRecognitionEngine;
- (void)suspendSpeechRecognition;
- (void)resumeSpeechRecognition;

@end
