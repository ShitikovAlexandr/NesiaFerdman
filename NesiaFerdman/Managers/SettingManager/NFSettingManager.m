//
//  NFSettingManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/22/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSettingManager.h"

#define GOOGLE_SYNC @"kGoogleSync"
#define WRITE_TO_GOOGLE @"kWriteToGoogle"
#define DELETE_FROM_GOOGLE @"kDeleteFromGoogle"

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL result = [defaults boolForKey:WRITE_TO_GOOGLE];
    return result;
}

+ (BOOL)isOnDeleteFromGoogle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL result = [defaults boolForKey:DELETE_FROM_GOOGLE];
    return result;
}


@end
