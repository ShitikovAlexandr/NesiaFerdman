//
//  NFStatisticWeekDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/17/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDateModel.h"
#import "NFWeekDateModel.h"


@interface NFStatisticWeekDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target;

- (void)setSelectedDate:(NFWeekDateModel*)week;
- (NFDateModel*)getDateLimits;

@end
