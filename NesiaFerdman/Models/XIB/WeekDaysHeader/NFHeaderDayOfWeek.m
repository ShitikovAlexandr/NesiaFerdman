//
//  NFHeaderDayOfWeek.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFHeaderDayOfWeek.h"

@implementation NFHeaderDayOfWeek


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.dayName = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2.0)];
    self.dayName.textAlignment = NSTextAlignmentCenter;
    self.dayName.font = [UIFont systemFontOfSize:14.f];
    
    self.dayValue = [[UILabel alloc]  initWithFrame:CGRectMake(0, self.dayName.frame.size.height, self.frame.size.width, self.frame.size.height/2.0)];
    self.dayValue.textAlignment = NSTextAlignmentCenter;
    self.dayValue.font = [UIFont systemFontOfSize:14.f];

    
    [self addSubview:_dayName];
    [self addSubview:_dayValue];
}

- (void)setDate:(NSDate*)date {
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.75;
    [self.dayValue.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    if ([[NSCalendar currentCalendar] isDate:[NSDate date] inSameDayAsDate:date]) {
        self.dayValue.textColor = [UIColor blackColor];
        self.dayName.textColor = [UIColor blackColor];
    } else {
        self.dayValue.textColor = [UIColor grayColor];
        self.dayName.textColor = [UIColor grayColor];
    }
    
    self.dayName.text = [self stringFromDate:date withFormat:@"E"];
    self.dayValue.text = [self stringFromDate:date withFormat:@"dd"];
}

- (NSString *)stringFromDate:(NSDate *)currentDate withFormat:(NSString*)format {
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    dateFormatter1.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    [dateFormatter1 setDateFormat:format];
    NSString* newDate = [dateFormatter1 stringFromDate:currentDate];
    return newDate;
}


@end
