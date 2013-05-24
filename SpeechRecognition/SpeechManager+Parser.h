//
//  SpeechManager+Parser.h
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "SpeechManager.h"

@interface SpeechManager (Parser)

- (void)parseSpeechHypothesis:(NSString *)speech;

@end
