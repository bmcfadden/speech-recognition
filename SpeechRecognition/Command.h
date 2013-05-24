//
//  Command.h
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-22.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CommandTypeIgnore = 0,
    CommandTypeAffirmative,
    CommandTypeAvailable,
    CommandTypeConnectTo,
    CommandTypeNegative,
    CommandTypePlayMessage,
    CommandTypeSendMessageTo,
} CommandType;

@interface Command : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) CommandType type;

// Designated initializer.
- (id)initWithCommand:(NSString *)command ofType:(CommandType)type;


@end
