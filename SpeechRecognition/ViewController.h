//
//  ViewController.h
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const SMPromptCheckingAvailability;
FOUNDATION_EXPORT NSString *const SMPromptConnected;
FOUNDATION_EXPORT NSString *const SMPromptConnecting;
FOUNDATION_EXPORT NSString *const SMPromptContactRequest;
FOUNDATION_EXPORT NSString *const SMPromptFindContactRequest;
FOUNDATION_EXPORT NSString *const SMPromptConnectRequest;
FOUNDATION_EXPORT NSString *const SMPromptIdle;
FOUNDATION_EXPORT NSString *const SMPromptMain;
FOUNDATION_EXPORT NSString *const SMPromptNotReady;
FOUNDATION_EXPORT NSString *const SMPromptPreparingToRecord;
FOUNDATION_EXPORT NSString *const SMPromptReady;
FOUNDATION_EXPORT NSString *const SMPromptRecentMessage;
FOUNDATION_EXPORT NSString *const SMPromptRecordMessage;
FOUNDATION_EXPORT NSString *const SMPromptSendMessageRequest;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *recognizedSpeechLabel;
@property (weak, nonatomic) IBOutlet UITextView *speechPromptTextView;
@property (weak, nonatomic) IBOutlet UILabel *speechStatusLabel;

- (IBAction)swipeGestureLeft:(id)sender;
- (IBAction)swipeGestureRight:(id)sender;

@end
