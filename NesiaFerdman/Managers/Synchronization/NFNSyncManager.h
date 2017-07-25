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
#import "NFNManifestation.h"
#import "NFNRsult.h"

@interface NFNSyncManager : NSObject

+ (NFNSyncManager *)sharedManager;

- (void)updateData;

- (void)writeEventToDataBase:(NFNEvent*)event;
- (void)writeValueToDataBase:(NFNValue*)value;
- (void)writeManifestationToDataBase:(NFNManifestation*)manifestation toValue:(NFNValue*)value;
- (void)writeResult:(NFNRsult*)resulte;
- (void)writeCalendarToDataBase:(NFGoogleCalendar*)calendar;

@end
