//
//  NFStatisticDayDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDateModel.h"

@interface NFStatisticDayDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target;

- (void)setSelectedDate:(NSDate*)date;
- (NFDateModel*)getDateLimits;


@end
