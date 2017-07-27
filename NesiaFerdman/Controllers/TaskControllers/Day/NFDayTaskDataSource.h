//
//  NFDayTaskDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDateModel.h"

@interface NFDayTaskDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableview target:(id)target;

- (NFDateModel*)getDateLimits;
- (void)setSelectedDate:(NSDate*)date;
- (void)setCurrentCellVisible;
- (NSArray*)setValueFilterData;

@end
