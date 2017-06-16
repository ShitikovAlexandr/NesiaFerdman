//
//  NFStatisticDetailController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/15/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFValue.h"

@interface NFStatisticDetailController : UIViewController
@property (strong, nonatomic) NFValue *value;
@property (strong, nonatomic) NSDate *selectedDate;

@end
