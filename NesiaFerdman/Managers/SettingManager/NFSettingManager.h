//
//  NFSettingManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/22/17.
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

+ (BOOL)isOnGoogleSync;
+ (BOOL)isOnWriteToGoogle;
+ (BOOL)isOnDeleteFromGoogle;

@end
