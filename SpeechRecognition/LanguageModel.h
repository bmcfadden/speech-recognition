//
//  LanguageModel.h
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-15.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageModel : NSObject

@property (nonatomic, strong) NSDictionary *lmGeneratorResults;
@property (nonatomic, strong) NSMutableArray *commandStringArray;
@property (nonatomic, strong) NSMutableArray *contactStringArray;
@property (nonatomic, strong) NSMutableDictionary *commandObjectDict;
@property (nonatomic, strong) NSMutableDictionary *wordObjectDict;
@property (nonatomic, strong) NSString *lmPath;
@property (nonatomic, strong) NSString *dictPath;

- (void)generateLanguageModel;

@end
