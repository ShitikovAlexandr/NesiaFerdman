//
//  NFStatisticRandomPeriodDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFStatisticRandomPeriodDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target;
- (void)setSelectedDate:(NSMutableArray*)dateArray;

@end
