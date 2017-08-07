//
//  NFGoogleSyncManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/SignIn.h>
#import <GTLRCalendar.h>
#import "NFNEvent.h"
#import "NFNGoogleEvent.h"
#import "NFGoogleCalendar.h"
@import Firebase;

#define APP_GOOGLE_CALENDAR_ID          @"kAppGoogleCalendarId"
#define NOTIFYCATIN_CALENDAR_LIST_LOAD  @"kCalendarListIsLoaded"
#define NOTIFYCATIN_EVENT_LOAD          @"kEventListIsLoaded"
#define LOGIN_FIREBASE                  @"kLoginFirebase"

@interface NFGoogleSyncManager : NSObject

+ (NFGoogleSyncManager *)sharedManager;

/** return an array of Calendars */
- (NSMutableArray<NFGoogleCalendar*>*)getCalendarList;

/** return an array of Events */
- (NSMutableArray<NFNEvent*>*)getEventList;

//*******************************

/** Load web login for Google */
- (void)loginActionWithTarget:(id)target;
/** logout from google */
- (void)logOutAction;
/** return true if user is logged in */
- (BOOL)isLogin ;

- (NSString*)getUserEmail;
- (NSURL*)getUserAvatarURL;
- (UIImage*)getUserAvatar;

/** Adds a new event to google calendar */
- (void)addNewEvent:(NFNEvent*)event;
/** update event in google calendar */
- (void)updateEvent:(NFNEvent*)event;
/** delete event from google calendar */
- (void)deleteEvent:(NFNEvent*)event;

/** download all events from calendars in array */
- (void)downloadGoogleEventsListWithCalendarsArray:(NSArray*)array;
/** download a list of all the available calendars for the user */
- (void)downloadGoogleCalendarList;

- (void)chackAPPCalendar;
- (void)resetCalendarList;

@end
