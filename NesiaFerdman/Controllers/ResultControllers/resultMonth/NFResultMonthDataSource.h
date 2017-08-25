//
//  NFResultMonthDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NFDateModel.h"

@interface NFResultMonthDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target;

- (void)setSelectedDate:(NSDate*)date;

@end
