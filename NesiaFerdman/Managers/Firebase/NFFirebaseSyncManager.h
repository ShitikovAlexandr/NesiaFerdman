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
#import "NFNQuote.h"
@import Firebase;

//notification keys

#define USER_UID [[[FIRAuth auth] currentUser] uid]

#define DATA_BASE_EVENT_LIST_DOWNLOADED                 @"kNotificationDataBaseCompliteLoadEventsList"
#define DATA_BASE_CALENDAR_LIST_DOWNLOADED              @"kNotificationDataBaseCompliteLoadCalendarsList"
#define DATA_BASE_USER_VALUE_LIST_DOWNLOADED            @"kNotificationDataBaseCompliteLoadUserValueList"
#define DATA_BASE_USER_MANIFESTATION_LIST_DOWNLOADED    @"kNotificationDataBaseCompliteLoadUserManifestationList"
#define DATA_BASE_APP_MANIFESTATION_LIST_DOWNLOADED     @"kNotificationDataBaseCompliteLoadAppManifestationList"
#define DATA_BASE_APP_RESULT_CATEGORY_LIST_DOWNLOADED   @"kNotificationDataBaseCompliteLoadResultCategoryList"
#define DATA_BASE_APP_VALUE_LIST_DOWNLOADED             @"kNotificationDataBaseCompliteLoadAppValueList"

#define DATA_BASE_COMPLITE_DOWNLOADED_ALL_DATA          @"kNotificationDataBaseCompliteLoadAllData"
#define QUOTE_END_LOAD                                  @"kQouteEndLoad"

@interface NFFirebaseSyncManager : NSObject

+ (NFFirebaseSyncManager*)sharedManager;

/** return an array of Events */
- (NSMutableArray<NFNEvent*>*)getEvensList;

/** return an array of Values */
- (NSMutableArray<NFNValue*>*)getValueList;

/** return an array of Manifestations */
- (NSMutableArray<NFNManifestation*>*)getUseManifestationList;

/** return an array of Results */
- (NSMutableArray<NFNRsult*>*)getResultList;

/** return an array of Calendars */
- (NSMutableArray<NFGoogleCalendar*>*)getCalendarList;

/** return an array of standart app Values */
- (NSMutableArray<NFNValue*>*)getAppValueList;

/** return an array of standart app result category */
- (NSMutableArray<NFNRsultCategory*>*)getResultCategoryList;

/** return an array of standart app Manifestations */
- (NSMutableArray<NFNManifestation*>*)getAppManifestationList;


//*********************

- (void)reset;

- (BOOL)isLogin;

- (void)downloadAllData;

- (void)writeEvent:(NFNEvent*)event;
- (void)writeValue:(NFNValue*)value;
- (void)writeManifestation:(NFNManifestation*)manifestation toValue:(NFNValue*)value;
- (void)writeResult:(NFNRsult*)result;
- (void)writeCalendar:(NFGoogleCalendar*)calendar;

- (void)deleteEvent:(NFNEvent*)event;
- (void)deleteValue:(NFNValue*)value;
- (void)deleteManifestation:(NFNManifestation*)manifestation;
- (void)deleteResult:(NFNRsult*)result;
- (void)deleteCalendar:(NFGoogleCalendar*)calendar;

//*********************

- (void)addCalendarToManager:(NFGoogleCalendar*)calendar;
- (void)addEventToManager:(NFNEvent*)event;
- (void)addValueToManager:(NFNValue*)value;
- (void)addManifestationToManager:(NFNManifestation*)manifestation;
- (void)addResultToManager:(NFNRsult*)result;

//*********************

- (void)removeCalendarFromManager:(NFGoogleCalendar*)calendar;
- (void)removeEventFromManager:(NFNEvent*)event;
- (void)removeValueFromManager:(NFNValue*)value;
- (void)removeManifestationFromManager:(NFNManifestation*)manifestation;
- (void)removeResultFromManager:(NFNRsult*)result;



//admin part

- (void)writAppValueToDataBase:(NFNValue*)value;
- (void)writeAppResultCategoryToDataBase:(NFNRsultCategory*)resultCategory;
- (void)writeAppManifestation:(NFNManifestation*)manifestation toValue:(NFNValue*)value;

- (void)writeQuoteToDataBase:(NFNQuote*)quote;
- (void)writeMinTime:(NSNumber*)min;
- (void)writeMaxTime:(NSNumber*)max;
- (void)writeMaxLimitGoogle:(NSNumber*)limit;

- (void)downloadQuoteList;
- (NSMutableArray*)getQuoteList;

@end
