//
//  Word.m
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-22.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "Word.h"

@implementation Word

- (id)initWithWord:(NSString *)word ofType:(WordType)type {
    self = [super init];
    
    if (self) {
        self.value = word;
        self.type = type;
    }
    
    return self;
}

@end
