//
//  NFAlertController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NFAlertController : NSObject


+ (void)alertDeleteProfileWithTarget:(id)target action:(SEL)userAction;
+ (void)alertDeleteGoogleEventWithTarget:(id)target action:(SEL)userAction;
+ (void)alertDeleteEventWithTarget:(id)target action:(SEL)userAction;


@end
