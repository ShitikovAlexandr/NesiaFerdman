//
//  NFResultMenuCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFResultCategory.h"
#import "NFWeekDateModel.h"

@interface NFResultMenuCell : UITableViewCell

- (void)addDataToCell:(NFResultCategory*)category date:(NFWeekDateModel*)currentDate;
- (void)addDataToDayCell:(NFResultCategory *)category date:(NSDate *)currentDate;

- (instancetype)initWithDefaultStyle;

@end
