//
//  NFFirebaseSyncManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/21/17.
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

#define USER_UID                                        [[[FIRAuth auth] currentUser] uid]
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

- (NSString*)getAppGoogleCalendarId;
- (void)writeAppCalendarId:(NSString*)calendarId;
- (void)writePushToken:(NSString*)tokenString;

//******************************************************************************************************************

/** reset all data in manager*/
- (void)reset;
/** retur TRUE if user is already logged in*/
- (BOOL)isLogin;
/** reload all Firebase data*/
- (void)downloadAllData;
/** write NFNEvent to Firebase*/
- (void)writeEvent:(NFNEvent*)event;
/** write NFNValue to Firebase*/
- (void)writeValue:(NFNValue*)value;
/** write  the manifestation in the Ашкуифыу with parent id, the parent id will be equal to the id of the NFNValue*/
- (void)writeManifestation:(NFNManifestation*)manifestation toValue:(NFNValue*)value;
/** write NFNRsult to Firebase*/
- (void)writeResult:(NFNRsult*)result;
/** write NFGoogleCalendar to Firebase*/
- (void)writeCalendar:(NFGoogleCalendar*)calendar;

/** set NFNEvent as  deleted event and writes this change to the Firebase*/
- (void)deleteEvent:(NFNEvent*)event;
/** set NFNValue as  deleted value and writes this change to the Firebase*/
- (void)deleteValue:(NFNValue*)value;
/** set NFNManifestation as  deleted value and writes this change to the Firebase*/
- (void)deleteManifestation:(NFNManifestation*)manifestation;
/** delete NFNRsult from Firebase*/
- (void)deleteResult:(NFNRsult*)result;
/** delete NFGoogleCalendar from Firebase*/
- (void)deleteCalendar:(NFGoogleCalendar*)calendar;

//******************************************************************************************************************

/** add NFGoogleCalendar only to the manager array */
- (void)addCalendarToManager:(NFGoogleCalendar*)calendar;
/** add NFNEvent only to the manager array */
- (void)addEventToManager:(NFNEvent*)event;
/** add NFNValue only to the manager array */
- (void)addValueToManager:(NFNValue*)value;
/** add NFNManifestation only to the manager array */
- (void)addManifestationToManager:(NFNManifestation*)manifestation;
/** add NFNRsult only to the manager array */
- (void)addResultToManager:(NFNRsult*)result;
/** return an array of NFQuote */
- (NSMutableArray*)getQuoteList;
- (void)deleteUser;

//******************************************************************************************************************

/**remove NFGoogleCalendar only from Manager array*/
- (void)removeCalendarFromManager:(NFGoogleCalendar*)calendar;
/**remove NFNEvent only from Manager array*/
- (void)removeEventFromManager:(NFNEvent*)event;
/**remove NFNValue only from Manager array*/
- (void)removeValueFromManager:(NFNValue*)value;
/**remove NFNManifestation only from Manager array*/
- (void)removeManifestationFromManager:(NFNManifestation*)manifestation;
/**remove NFNRsult only from Manager array*/
- (void)removeResultFromManager:(NFNRsult*)result;

// Options

- (void)getMinSyncInterval;
- (void)getMaxSyncInterval;
- (void)getLimitGoogleDownload;
- (void)downloadQuoteList;



//admin part

/** Warning!! This method is used only during development to add test data to Firebase*/
- (void)writAppValueToDataBase:(NFNValue*)value;
/** Warning!! This method is used only during development to add test data to Firebase*/
- (void)writeAppResultCategoryToDataBase:(NFNRsultCategory*)resultCategory;
/** Warning!! This method is used only during development to add test data to Firebase*/
- (void)writeAppManifestation:(NFNManifestation*)manifestation toValue:(NFNValue*)value;

/** Warning!! This method is used only during development to add test data to Firebase*/
- (void)writeQuoteToDataBase:(NFNQuote*)quote;
/** Warning!! This method is used only during development to add test data to Firebase*/
- (void)writeMinTime:(NSNumber*)min;
/** Warning!! This method is used only during development to add test data to Firebase*/
- (void)writeMaxTime:(NSNumber*)max;
/** Warning!! This method is used only during development to add test data to Firebase*/
- (void)writeMaxLimitGoogle:(NSNumber*)limit;



@end
