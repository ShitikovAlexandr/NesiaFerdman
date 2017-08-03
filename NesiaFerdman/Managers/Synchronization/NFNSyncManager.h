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
#import "NotifyList.h"

#define END_UPDATE @"kEndUpdate"

@interface NFNSyncManager : NSObject

+ (NFNSyncManager *)sharedManager;

- (void)updateData;

- (void)writeEventToDataBase:(NFNEvent*)event;
- (void)writeValueToDataBase:(NFNValue*)value;
- (void)writeManifestationToDataBase:(NFNManifestation*)manifestation toValue:(NFNValue*)value;
- (void)writeResult:(NFNRsult*)resulte;
- (void)writeCalendarToDataBase:(NFGoogleCalendar*)calendar;

- (void)addCalendarToDBManager:(NFGoogleCalendar*)calendar;
- (void)addEventToDBManager:(NFNEvent*)event;
- (void)addValueToDBManager:(NFNValue*)value;
- (void)addManifestationToDBManager:(NFNManifestation*)manifestation;
- (void)addResultToDBManager:(NFNRsult*)result;

- (void)removeCalendarFromDBManager:(NFGoogleCalendar*)calendar;
- (void)removeEventFromDBManager:(NFNEvent*)event;
- (void)removeValueFromDBManager:(NFNValue*)value;
- (void)removeManifestationDBFromManager:(NFNManifestation*)manifestation;
- (void)removeResultFromDBManager:(NFNRsult*)result;

- (void)removeCalendarFromDB:(NFGoogleCalendar*)calendar;
- (void)removeEventFromDB:(NFNEvent*)event;
- (void)removeValueFromDB:(NFNValue*)value;
- (void)removeManifestationDB:(NFNManifestation*)manifestation;
- (void)removeResultFromDB:(NFNRsult*)result;
- (void)resetSelectedValuesList;
- (void)addValuesToSelectedList:(NSArray*)array;

- (BOOL)isFirstRunToday;
- (BOOL)isFirstRunApp;

- (void)updateDataSource;
- (void)updateValueDataSource;
- (void)updateManifestationDataSource;

//google

- (void)addNewEventToGoogle:(NFNEvent*)event;
- (void)deleteEventFromGoogle:(NFNEvent*)event;
- (void)updateGoogleEvent:(NFNEvent*)event;

- (void)reset;

@end
