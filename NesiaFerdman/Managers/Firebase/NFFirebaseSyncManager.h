//
//  NFFirebaseSyncManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFNEvent.h"
#import "NFNValue.h"
#import "NFNRsultCategory.h"
#import "NFNRsult.h"
#import "NFNManifestation.h"
#import "NFGoogleCalendar.h"
@import Firebase;


@interface NFFirebaseSyncManager : NSObject

+ (NFFirebaseSyncManager*)sharedManager;

- (BOOL)isLogin;

- (void)loadAllData;

- (void)writeEvent:(NFNEvent*)event;
- (void)writeCalendar:(NFGoogleCalendar*)calendar;

@end
