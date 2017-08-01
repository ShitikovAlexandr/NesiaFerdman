//
//  NFSettingManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/22/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSettingManager.h"

#define ALL_AVALIBLE_CALENDARS @"kAllAvalibleCalendars"
#define ALL_ENABLE_CALENDARS   @"kAllEnabledCalendars"

#define GOOGLE_SYNC @"kGoogleSync"
#define WRITE_TO_GOOGLE @"kWriteToGoogle"
#define DELETE_FROM_GOOGLE @"kDeleteFromGoogle"

#define MIN_PERIOD @"kMinPeriod"
#define MAX_PERIOD @"kMaxPeriod"


@implementation NFSettingManager

// Google sync
+ (void)setOnGoogleSync {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:GOOGLE_SYNC];
}

+ (void)setOffGoogleSync {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:GOOGLE_SYNC];
}

+ (void)setOnWriteToGoogle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:WRITE_TO_GOOGLE];
}

+ (void)setOffWriteToGoogle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:WRITE_TO_GOOGLE];
}

+ (void)setOnDeleteFromGoogle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:DELETE_FROM_GOOGLE];
}

+ (void)setOffDeleteFromGoogle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:DELETE_FROM_GOOGLE];
}

+ (BOOL)isOnGoogleSync {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL result = [defaults boolForKey:GOOGLE_SYNC];
    return result;
}

+ (BOOL)isOnWriteToGoogle {
    if ([self isOnGoogleSync]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL result = [defaults boolForKey:WRITE_TO_GOOGLE];
        return result;
    }
    return false;
}

+ (BOOL)isOnDeleteFromGoogle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL result = [defaults boolForKey:DELETE_FROM_GOOGLE];
    return result;
}

// Synchronization boundaries

+ (void)setStandartIntervalsOfSync {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:95 forKey:MIN_PERIOD];
    [defaults setInteger:95 forKey:MAX_PERIOD];
}

+ (void)setMinIntervalOfSync:(NSNumber*)dayInterval {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[dayInterval integerValue] forKey:MIN_PERIOD];
}

+ (void)setMaxIntervalOfSync:(NSNumber*)dayInterval {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[dayInterval integerValue] forKey:MAX_PERIOD];
}

+ (NSInteger)getMinPerionOfSync {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger result =  [defaults integerForKey:MIN_PERIOD];
    return result < 30 ? 120 : result;
}

+ (NSInteger)getMaxPerionOfSync {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger result =  [defaults integerForKey:MAX_PERIOD];
    return result < 30 ? 120 : result;
}

+ (NSDate*)getMinDate {
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-86400 * [self getMinPerionOfSync]];
    return startDate;
}

+ (NSDate*)getMaxDate {
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:86400 * [self getMaxPerionOfSync]];
    return endDate;
}

+ (NSArray*)getAllAvalibleCalendars {
    return nil;
}

+ (NSArray*)getAllEnabledCalendars {
    return nil;
}

+ (void)setAllAvalibleCalendars:(NSArray*)calendarList {
    
}

+ (void)setAllEnabledCalendars:(NSArray*)calendarList {
    
}



@end
