//
//  NFNSyncManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/24/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFAdminManager.h"
#import "NFNEvent.h"
#import "NFGoogleCalendar.h"
@interface NFNSyncManager : NSObject

+ (NFNSyncManager *)sharedManager;

//- (void)loadDataFromDataBase;
//- (void)loadDataFromGoogle;

- (void)updateData;

- (void)writeEventToDataBase:(NFNEvent*)event;
- (void)writeCalendarToDataBase:(NFGoogleCalendar*)calendar;

@end
