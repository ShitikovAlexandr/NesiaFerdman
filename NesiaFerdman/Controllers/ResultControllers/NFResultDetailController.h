//
//  NFResultDetailController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFResultCategory.h"
#import "NFWeekDateModel.h"

@interface NFResultDetailController : UIViewController
@property (strong, nonatomic) NFResultCategory *selectedCategory;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NFWeekDateModel *week;

@end
