//
//  NFDayTableViewCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDayTableViewCell.h"
#import "NFDataSourceManager.h"
#import "NFStyleKit.h"

@interface NFDayTableViewCell()
@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UIView *taskCircleView;
@property (strong, nonatomic) UIView *taskCircleViewUpLine;
@property (strong, nonatomic) UIView *taskCircleViewDownLine;

@property (strong, nonatomic) UIView *lineView;
@property (assign, nonatomic) BOOL isCurrentTime;
@property (assign, nonatomic) BOOL isMenyTask;
@property (assign, nonatomic) BOOL isTask;


@end

@implementation NFDayTableViewCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.timeLabel.layer.cornerRadius = self.timeLabel.frame.size.height/2.f;
    self.timeLabel.layer.masksToBounds = true;
    CGFloat ovalRadius = 6.f;
    _topLine.backgroundColor = [NFStyleKit sUPER_LIGHT_GREEN];
    _downLine.backgroundColor = [NFStyleKit sUPER_LIGHT_GREEN];
    self.timeLabel.backgroundColor = [NFStyleKit _base_GREY];
    self.timeLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.timeLabel.layer.borderWidth = 2;
    
    _taskCircleView = [[UIView alloc] initWithFrame:CGRectMake(_timeLabel.center.x - ovalRadius, _timeLabel.center.y - ovalRadius, ovalRadius * 2, ovalRadius * 2)];
    _taskCircleView.layer.cornerRadius = ovalRadius;
    _taskCircleView.layer.borderWidth = 4.f;
    _taskCircleView.layer.borderColor = [NFStyleKit sUPER_LIGHT_GREEN].CGColor;
    _taskCircleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_taskCircleView];
    _taskCircleView.hidden = YES;
    
    if (_isCurrentTime) {
        _circleView.hidden = false;
        _lineView.hidden = false;
        self.timeLabel.backgroundColor = [NFStyleKit bASE_GREEN];
        self.timeLabel.textColor = [UIColor whiteColor];
    }
    if (_isMenyTask) {
        _taskCircleView.hidden = false;
    }
    if (_isTask) {
        self.timeLabel.layer.borderColor = [NFStyleKit bASE_GREEN].CGColor;
    }
}

- (void) addData:(NSMutableArray *)events withIndexPath:(NSIndexPath *)index date:(NSDate*)currentDate {
//    NSArray *filtredArray = [NSArray arrayWithArray:[[NFDataSourceManager sharedManager] getEventForHour:index.section  WithArray:events]];
       NSArray *filtredArray =[NSArray arrayWithArray:[[NFDataSourceManager sharedManager] getEventForHour:index.section date:currentDate fromArray:events]];
    self.timeLabel.hidden = true;
    self.topLine.hidden = YES;
    self.downLine.hidden = YES;
    self.calendarColorView.backgroundColor = [UIColor clearColor];
    if (index.row > 0) {
        _isMenyTask = true;
        self.topLine.hidden = false;
    }
    
    if (filtredArray.count > 0) {
        self.downLine.hidden = false;
        NFNEvent *event = [filtredArray objectAtIndex:index.row];
        _event = event;
        NSString *hexColor = [[NFDataSourceManager sharedManager] getHexColorWithGoogleCalendarId:event.calendarID];
        self.calendarColorView.backgroundColor = [NFStyleKit colorFromHexString:hexColor];
        self.titleLabel.text = event.title;
        _isTask = true;
        self.timeTaskLabel.text = [self getTimeStringFromEvent:_event]; //[NSString stringWithFormat:@"%@-%@", [self dateFormater:event.startDate],[self dateFormater:event.endDate]];
        if (index.row == filtredArray.count - 1) {
            self.separatorInset = UIEdgeInsetsZero;
            self.downLine.hidden = true;
        }
        
        if (event.isDone) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_enable.png"]];
            self.accessoryView = imageView;
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_disable.png"]];
            self.accessoryView = imageView;
        }
    } else {
        self.timeLabel.backgroundColor = [NFStyleKit _base_GREY];
        self.separatorInset = UIEdgeInsetsZero;
    }
    
    if (index.row == 0) {
        self.timeLabel.hidden = false;
        NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"HH"];
        NSString* newTime = [dateFormatter1 stringFromDate:[NSDate date]];
        NSString *currentTime = [NSString stringWithFormat:@"%02ld", (long)index.section];
        self.timeLabel.text = currentTime;
        
        if ([newTime isEqualToString:currentTime] && [[NSCalendar currentCalendar] isDate:[NSDate date] inSameDayAsDate:currentDate]) {
            _isCurrentTime = true;
        }
    }
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HH"];
    NSString* newTime = [dateFormatter1 stringFromDate:[NSDate date]];
    NSString *currentTime = [NSString stringWithFormat:@"%02ld", (long)index.section];
    if ([newTime isEqualToString:currentTime] && [[NSCalendar currentCalendar] isDate:[NSDate date] inSameDayAsDate:currentDate]) {
        self.backgroundColor = [[NFStyleKit bASE_GREEN] colorWithAlphaComponent:0.05];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.accessoryView.frame = CGRectMake(self.accessoryView.frame.origin.x, self.accessoryView.frame.origin.y, 18, 18);
}

- (void) prepareForReuse {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    _isTask = false;
    self.isCurrentTime = false;
    self.isMenyTask = false;
    self.titleLabel.text = @"";
    self.timeTaskLabel.text = @"";
    [self.lineView removeFromSuperview];
    [self.circleView removeFromSuperview];
    self.accessoryView = nil;
    self.timeLabel.backgroundColor = [NFStyleKit _base_GREY];
    self.timeLabel.textColor = [UIColor blackColor];
    self.separatorInset = UIEdgeInsetsMake(0, 90.0, 0, 0);
    [_taskCircleView removeFromSuperview];
    self.timeLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.event = nil;
    _calendarColorView.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
}


- (NSString *)dateFormater:(NSString *)dateString {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:16]];
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    NSString* newDate = [dateFormatter1 stringFromDate:dateFromString];
    return newDate;
}

- (NSDate*) dateWithNoTime {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

- (NSString*)getTimeStringFromEvent:(NFNEvent*)event {
    NSString *result = @"";
    NSDate *start = [self datefromString:event.startDate];
    NSDate *end = [self datefromString:event.endDate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if (![calendar isDate:[self dateWithNoTime:start] inSameDayAsDate:[self dateWithNoTime:end]]) {
        NSLog(@"is repeat event %@ - %@", event.startDate, event.endDate);
        NSLog(@"list of repeat date %@", [self getListOfDateWithStart:start end:end]);
        if ([self getListOfDateWithStart:start end:end].count > 1) {
            result = [NSString stringWithFormat:@"%@\n%@", [self stringFromDate:start],[self stringFromDate:end]];
        } else {
            result = [NSString stringWithFormat:@"%@-%@", [self dateFormater:event.startDate],[self dateFormater:event.endDate]];
        }
    } else {
        result = [NSString stringWithFormat:@"%@-%@", [self dateFormater:event.startDate],[self dateFormater:event.endDate]];
    }
    return result;
}

- (NSMutableArray*)getListOfDateWithStart:(NSDate*)start end:(NSDate*)end {
    NSMutableArray *result = [NSMutableArray new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:start
                                                 toDate:end
                                                options:0];
    NSInteger numberOfDays = components.day;
    
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    [result addObject:start];
    
    for (int i = 1; i <= numberOfDays; i++) {
        [offset setDay:i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:start options:0];
        [result addObject:nextDay];
    }
    if (result.count == 1) {
        NSLog(@"result");
    }
    return result;
}

- (NSDate*)datefromString:(NSString*)dateString {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    if (dateString.length >=16) {
        NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:16]];
        return dateFromString;
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:10]];
        return dateFromString;
    }
}

- (NSDate*) dateWithNoTime:(NSDate*)date {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

- (NSString*)stringFromDate:(NSDate*)date {
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"dd/MM/yy\tHH:mm"];
    NSString* newDate = [dateFormatter1 stringFromDate:date];
    return newDate;
}




@end
