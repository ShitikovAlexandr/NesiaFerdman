//
//  NFSyncManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/26/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFFirebaseManager.h"
#import "NFGoogleManager.h"
#import "NFPhoneManager.h"
#import "NFTaskManager.h"
#import "NotifyList.h"
#import "NFValue.h"

@interface NFSyncManager : NSObject

@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong , nonatomic) NSString *userId;

+ (NFSyncManager *)sharedManager;


- (void)updateAllData;
- (void)clearAllData;
- (void)writeEventToFirebase:(NFEvent *)event;
- (void)addStandartListOfValue;
- (void)writeValueToFirebase:(NFValue *)value;
- (void)deleteValueFromFirebase:(NFValue *)value;

- (BOOL)isFirstRunApp;
- (BOOL)isFirstRunToday;





@end
