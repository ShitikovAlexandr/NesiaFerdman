//
//  NFSyncManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/26/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NFFirebaseManager.h"
//#import "NFGoogleManager.h"
#import "NFTaskManager.h"
#import "NotifyList.h"
#import "NFValue.h"
#import "NFGoogleCalendar.h"
#warning lock at Google manager in this class


@interface NFSyncManager : NSObject

@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong , nonatomic) NSString *userId;

+ (NFSyncManager *)sharedManager;

- (void)updateAllData;
- (void)clearAllData;
- (void)writeEventToFirebase:(NFEvent *)event;
- (void)addStandartListOfValue;
- (void)addStandartListOfMainifestations;
- (void)addStandartListOfResultCategory;
- (void)writeValueToFirebase:(NFValue *)value;
//- (void)writeResultToFirebase:(NFResult*)result;
- (void)deleteValueFromFirebase:(NFValue *)value;
- (void)deleteEventFromFirebase:(NFEvent *)event;

- (void)writeNewEventWithSetting:(NFEvent*)event;
- (void)editEventWithSetting:(NFEvent*)event;
- (void)deleteEventWithSetting:(NFEvent*)event;


- (BOOL)isFirstRunApp;
- (BOOL)isFirstRunToday;

- (void)writeEventToGoogle:(NFEvent*)event;
- (void)updateEventInGoogleWithEvent:(NFEvent*)event;
- (void)deleteEventFromGoogle:(NFEvent*)event;

/** Return the list of calendars available to the user */
- (NSMutableArray*)getGoogleCalendarsList;

/** Save Google calendar to Firebase */
- (void)saveGoogleCalendar:(NFGoogleCalendar*)calendar;

+ (BOOL)connectedInternet;

- (NSMutableArray*)getListOfManifestationFromValue:(NFValue*)value;
- (void)addMainifestation:(NFManifestation*)manifestation toValue:(NFValue*)value;




@end
