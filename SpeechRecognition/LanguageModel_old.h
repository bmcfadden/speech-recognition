//
//  LanguageModel.h
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const SpeechCatCmdAffirmative;
FOUNDATION_EXPORT NSString *const SpeechCatCmdAvailable;
FOUNDATION_EXPORT NSString *const SpeechCatCmdConnect;
FOUNDATION_EXPORT NSString *const SpeechCatCmdNegative;
FOUNDATION_EXPORT NSString *const SpeechCatCmdSend;
FOUNDATION_EXPORT NSString *const SpeechCatCmdPlay;
FOUNDATION_EXPORT NSString *const SpeechCatContact;
FOUNDATION_EXPORT NSString *const SpeechCatIgnore;

@interface LanguageModel : NSObject

@property (nonatomic, strong) NSArray *contactArray;
@property (nonatomic, strong) NSDictionary *commandDict;
@property (nonatomic, strong) NSDictionary *contactDict;
@property (nonatomic, strong) NSDictionary *lmGeneratorResults;
@property (nonatomic, strong) NSDictionary *supportDict;
@property (nonatomic, strong) NSMutableDictionary *completeDict;
@property (nonatomic, strong) NSString *lmPath;
@property (nonatomic, strong) NSString *dicPath;

- (void)generateLanguageModel;

@end
