//
//  Word.h
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-22.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WordTypeIgnore = 0,
    WordTypeCommand,
    WordTypeContact,
} WordType;

@interface Word : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) WordType type;

// Designated initializer.
- (id)initWithWord:(NSString *)word ofType:(WordType)type;

@end
