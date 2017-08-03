//
//  NFResultMenuCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNRsultCategory.h"
#import "NFWeekDateModel.h"

@interface NFResultMenuCell : UITableViewCell

- (void)addDataToCell:(NFNRsultCategory*)category date:(NFWeekDateModel*)currentDate;
- (void)addDataToDayCell:(NFNRsultCategory *)category date:(NSDate *)currentDate;
- (void)addDataToMonthCell:(NFNRsultCategory*)category date:(NSDate*)currentDate;

- (instancetype)initWithDefaultStyle;

@end
