//
//  Command.m
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-22.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import "Command.h"

@implementation Command

- (id)initWithCommand:(NSString *)command ofType:(CommandType)type {
    self = [super init];
    
    if (self) {
        self.value = command;
        self.type = type;
    }
    
    return self;
}

@end
