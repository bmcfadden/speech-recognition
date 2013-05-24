//
//  SpeechManager.h
//  SpeechRecognition
//
//  Created by Brian McFadden on 2013-05-14.
//  Copyright (c) 2013 Perch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenEars/FliteController.h>
#import <OpenEars/OpenEarsEventsObserver.h>
#import <OpenEars/PocketsphinxController.h>
#import <Slt/Slt.h>
#import "Command.h"
#import "LanguageModel.h"

typedef enum {
    SMStateCheckingAvailability,    // In the process of checking a user's availability. (no command, no contact)
    SMStateConnected,               // Connected to a user. (no command, no contact)
    SMStateConnecting,              // In the process of connecting to a user. (no command, no contact)
    SMStateConnectRequest,          // Someone is available, asking user if they would like to connect. (yes command, no contact)
    SMStateContactRequest,          // Multiple contacts with same name found, asking user which one to use. (no command, yes contact)
    SMStateFindContactRequest,      // Asking user if they would like to find someone else. (yes command, no contact)
    SMStateIdle,                    // Speech manager is not active. (no command, no contact)
    SMStateMain,                    // Asking a user what they would like to do. (yes command, yes contact)
    SMStateNotReady,                // Calibration is not yet complete. (no command, no contact)
    SMStatePreparingToRecord,       // In the process of preparing to record. (no command, no contact)
    SMStateReady,                   // Calibration is complete. (no command, no contact)
    SMStateRecentMessage,           // Playing a recent message. (no command, no contact)
    SMStateRecordMessage,           // Recording a recent message. (no command, no contact)
    SMStateSendMessageRequest,      // Contact is unavailable, asking if user would like to send them a message. (yes command, no contact)
    
} SpeechManagerState;

FOUNDATION_EXPORT NSString *const SpeechManagerDidUpdateNotification;

@interface SpeechManager : NSObject <OpenEarsEventsObserverDelegate>

@property (nonatomic, strong) Command *command;
@property (nonatomic, strong) FliteController *fliteController;
@property (nonatomic, strong) LanguageModel *languageModel;
@property (nonatomic, strong) NSMutableArray *contactSuggestionArray;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *hypothesis;
@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;
@property (nonatomic, assign) SpeechManagerState state;

+ (SpeechManager *)shared;

- (void)performCommand:(NSString *)commandString withContact:(NSString *)contactString;

@end
