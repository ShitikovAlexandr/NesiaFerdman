//
//  NFResultDetailController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNRsultCategory.h"
#import "NFWeekDateModel.h"

@interface NFResultDetailController : UIViewController
@property (strong, nonatomic) NFNRsultCategory *selectedCategory;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NFWeekDateModel *week;
@property (strong, nonatomic) NSDate* monthDate;

@end
