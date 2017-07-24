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
#import "NFEvent.h"
@import Firebase;

#define NOTIFYCATIN_CALENDAR_LIST_LOAD @"kCalendarListIsLoaded"
#define NOTIFYCATIN_EVENT_LOAD @"kEventListIsLoaded"

@interface NFGoogleSyncManager : NSObject



+ (NFGoogleSyncManager *)sharedManager;


/** Load web login for Google */
- (void)loginActionWithTarget:(id)target;
/** logout from google */
- (void)logOutAction;
/** return true if user is logged in */
- (BOOL)isLogin ;
/** retur user id (NSString) */
- (NSString*)getUserId;

/** Adds a new event to google calendar */
- (void)addNewEvent:(NFEvent*)event;
/** update event in google calendar */
- (void)updateEvent:(NFEvent*)event;
/** delete event from google calendar */
- (void)deleteEvent:(NFEvent*)event;

/** load all events from calendars in array */
- (void)loadGoogleEventsListWithCalendarsArray:(NSArray*)array;
/** load a list of all the available calendars for the user */
- (void)loadGoogleCalendarList;


@end
