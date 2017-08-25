//
//  NFStatisticMonthDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/17/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDateModel.h"

@interface NFStatisticMonthDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target;


- (void)setSelectedDate:(NSDate*)date;

@end
