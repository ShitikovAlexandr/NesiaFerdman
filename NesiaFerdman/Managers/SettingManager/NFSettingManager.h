//
//  NFSettingManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/22/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFSettingManager : NSObject

// Google sync
+ (void)setOnGoogleSync;
+ (void)setOffGoogleSync;

+ (void)setOnWriteToGoogle;
+ (void)setOffWriteToGoogle;

+ (void)setOnDeleteFromGoogle;
+ (void)setOffDeleteFromGoogle;

/** Return true is Google sync is ON */
+ (BOOL)isOnGoogleSync;
/** Return true if  Google Calendar write function is ON */
+ (BOOL)isOnWriteToGoogle;
/** Return true if  Google Calendar delete function is ON */
+ (BOOL)isOnDeleteFromGoogle;

/** Set the date of the start of synchronization to the NSUserDefalts */
+ (void)setMinIntervalOfSync:(NSNumber*)dayInterval;
/** Set the date of the end of synchronization to the NSUserDefalts */
+ (void)setMaxIntervalOfSync:(NSNumber*)dayInterval;
/** Return synchronization start date */
+ (NSDate*)getMinDate;
/** Return synchronization end date */
+ (NSDate*)getMaxDate;

+ (void)setDownloadGoogleLimit:(NSNumber*)limit;
+ (NSInteger)getDownloadGoogleLimit;

/** Return a list of all  Google calendars(Ids) available to the user, saved in the NSUserDefalts */
+ (NSArray*)getAllAvalibleCalendars;
/** Return a list of all  Google calendars(Ids) enabled by the user, saved in the NSUserDefalts */
+ (NSArray*)getAllEnabledCalendars;
/** Set a list of all  Google calendars(Ids) available to the user in the NSUserDefaults */
+ (void)setAllAvalibleCalendars:(NSArray*)calendarList;
/** Set a list of all  Google calendars(Ids) enabled by the user in the NSUserDefaults */
+ (void)setAllEnabledCalendars:(NSArray*)calendarList;

@end
