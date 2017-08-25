//
//  NFMonthTaskDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/28/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFMonthTaskDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView
                           target:(id)target
                     calendarView:(id)calendarView;

- (NSArray*)setValueFilter;
- (NSDate*)setMinDate;
- (NSDate*)setMaxDate;
- (void)setSelectedDate:(NSDate*)date;
- (NSMutableDictionary*)setEventDictionary ;

@end
