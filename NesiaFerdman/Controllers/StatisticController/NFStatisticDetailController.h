//
//  NFStatisticDetailController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/15/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNValue.h"
#import "NFNEvent.h"
#import "NFViewController.h"
#import "NFWeekDateModel.h"

typedef NS_ENUM(NSUInteger, StatisticDetailType)
{
    DayStatistic,
    WeekStatistic,
    MonthStatistic,
    OtherStatistic,
};

@interface NFStatisticDetailController : NFViewController
@property (strong, nonatomic) NFNValue *value;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NFWeekDateModel *selectedWeek;
@property (strong, nonatomic) NSMutableArray *selectedDateArray;
@property (assign, nonatomic) StatisticDetailType type;

@end
