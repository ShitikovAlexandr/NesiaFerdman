//
//  NFDateModel.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDateModel.h"
#import "NFWeekDateModel.h"

@interface NFDateModel()

@end

@implementation NFDateModel

- (instancetype)initWithStartDate:(NSDate *)start endDate:(NSDate *)end {
    self = [super init];
    if (self) {
        _startDate = start;
        _endDate = end;
        _currentDate = [NSDate date];
        NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        _currentDateString = [dateFormatter stringFromDate:[NSDate date]];
        self.fromToDateArray = [NSMutableArray array];
        self.fromToDateArray = [self getDateListFrom:start to:end];
        self.weekArray = [NSMutableArray array];
        self.weekArray = [self getWeeksFrom:start to:end];
    }
    return self;
}

- (NSMutableArray *)getDateListFrom:(NSDate *)from to:(NSDate *)to {
    
    NSMutableArray *dateList = [NSMutableArray array];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [currentCalendar setFirstWeekday:2];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [dateList addObject: from];
    NSDate *currentDate = from;
    currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    while ( [to compare: currentDate] != NSOrderedAscending) {
        [dateList addObject: currentDate];
        currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    }
    return dateList;
}

- (NSMutableArray *)getWeeksFrom:(NSDate *)from to:(NSDate *)to {
    
    NSMutableArray *weeksArray = [NSMutableArray array];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];;
//    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setFirstWeekday:2];
    
    NSDate *now = from;
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;
    
    [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    while ([to compare: endOfWeek] != NSOrderedAscending) {
        NFWeekDateModel *week = [[NFWeekDateModel alloc] init];
        endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-86400];
        week.startOfWeek = startOfTheWeek;
        week.endOfWeek = endOfWeek;
        week.allDateOfWeek = [NSMutableArray array];
        week.allDateOfWeek = [self getDateListFrom:startOfTheWeek to:endOfWeek];
        [weeksArray addObject:week];
        startOfTheWeek = [endOfWeek dateByAddingTimeInterval:86400];
    }
    return weeksArray;
}

@end




