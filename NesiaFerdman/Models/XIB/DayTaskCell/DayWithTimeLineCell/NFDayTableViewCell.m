//
//  NFDayTableViewCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDayTableViewCell.h"
#import "NFTaskManager.h"
#import "NFStyleKit.h"

@interface NFDayTableViewCell()
@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UIView *taskCircleView;
@property (strong, nonatomic) UIView *taskCircleViewUpLine;
@property (strong, nonatomic) UIView *taskCircleViewDownLine;

@property (strong, nonatomic) UIView *lineView;
@property (assign, nonatomic) BOOL isCurrentTime;
@property (assign, nonatomic) BOOL isMenyTask;

@end

@implementation NFDayTableViewCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.timeLabel.layer.cornerRadius = self.timeLabel.frame.size.height/2.f;
    self.timeLabel.layer.masksToBounds = true;
//    [self addSubview:_downBorder];
    CGFloat ovalRadius = 6.f;
    CGFloat timelineWidth = 2.f;
    _topLine.backgroundColor = [NFStyleKit sUPER_LIGHT_GREEN];
    _downLine.backgroundColor = [NFStyleKit sUPER_LIGHT_GREEN];

    
    // time circle with line
    
    _circleView = [[UIView alloc] initWithFrame:CGRectMake(_timeLabel.frame.origin.x - ovalRadius, _timeLabel.center.y - ovalRadius, ovalRadius * 2, ovalRadius * 2)];
    _circleView.layer.cornerRadius = ovalRadius;
    _circleView.layer.borderWidth = 4.f;
    _circleView.layer.borderColor = [NFStyleKit sUPER_LIGHT_GREEN].CGColor;
    [self addSubview:_circleView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _timeLabel.center.y, _circleView.frame.origin.x, timelineWidth)];
    _lineView.backgroundColor = [NFStyleKit sUPER_LIGHT_GREEN];
    [self addSubview: _lineView];
    _circleView.hidden = true;
    _lineView.hidden = true;

    
    //task circle with line
    
//    _taskCircleViewUpLine = [[UIView alloc] initWithFrame:CGRectMake(_taskCircleView.center.x, 0, timelineWidth, rect.size.height/2)];
//    _taskCircleViewUpLine.backgroundColor = [NFStyleKit sUPER_LIGHT_GREEN];
//    [self addSubview: _taskCircleViewUpLine];
//    //_taskCircleViewUpLine.hidden = YES;
//    
//    _taskCircleViewDownLine = [[UIView alloc] initWithFrame:CGRectMake(_taskCircleView.center.x, _taskCircleView.center.y, timelineWidth, rect.size.height/2)];
//    _taskCircleViewDownLine.backgroundColor = [NFStyleKit sUPER_LIGHT_GREEN];
//    [self addSubview: _taskCircleViewDownLine];
//    //_taskCircleViewDownLine.hidden = YES;
    
    _taskCircleView = [[UIView alloc] initWithFrame:CGRectMake(_timeLabel.center.x - ovalRadius, _timeLabel.center.y - ovalRadius, ovalRadius * 2, ovalRadius * 2)];
    _taskCircleView.layer.cornerRadius = ovalRadius;
    _taskCircleView.layer.borderWidth = 4.f;
    _taskCircleView.layer.borderColor = [NFStyleKit sUPER_LIGHT_GREEN].CGColor;
    //_taskCircleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_taskCircleView];
    _taskCircleView.hidden = YES;
    
    
    
    //chack state to display
    
    if (_isCurrentTime) {
        _circleView.hidden = false;
        _lineView.hidden = false;
    }
    if (_isMenyTask) {
        _taskCircleView.hidden = false;
    }
}

- (void) addData:(NSMutableArray *)events withIndexPath:(NSIndexPath *)index date:(NSDate*)currentDate {
    NSArray *filtredArray = [NSArray arrayWithArray:[[NFTaskManager sharedManager] getTaskForHour:index.section  WithArray:events]];
    self.timeLabel.hidden = true;
    self.topLine.hidden = YES;
    self.downLine.hidden = YES;
    if (index.row > 0) {
        _isMenyTask = true;
        self.topLine.hidden = false;
    }
    
    if (filtredArray.count > 0) {
        self.downLine.hidden = false;
        NFEvent *event = [filtredArray objectAtIndex:index.row];
        _event = event;
        self.titleLabel.text = event.title;
        self.timeLabel.backgroundColor = [NFStyleKit bASE_GREEN];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeTaskLabel.text = [NSString stringWithFormat:@"%@-%@", [self dateFormater:event.startDate],[self dateFormater:event.endDate]];
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
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"HH"];
        NSString* newTime = [dateFormatter1 stringFromDate:[NSDate date]];
        NSString *currentTime = [NSString stringWithFormat:@"%02ld", (long)index.section];
        self.timeLabel.text = currentTime;
        
        if ([newTime isEqualToString:currentTime] && [[NSCalendar currentCalendar] isDate:[NSDate date] inSameDayAsDate:currentDate]) {
            _isCurrentTime = true;
        }
    } else {

    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.accessoryView.frame = CGRectMake(self.accessoryView.frame.origin.x, self.accessoryView.frame.origin.y, 18, 18);
}

- (void) prepareForReuse {
    self.isCurrentTime = false;
    self.isMenyTask = false;
    self.titleLabel.text = @"";
    self.timeTaskLabel.text = @"";
    [self.lineView removeFromSuperview];
    [self.circleView removeFromSuperview];
    self.accessoryView = nil;
    self.timeLabel.backgroundColor = [NFStyleKit _base_GREY];
    self.timeLabel.textColor = [UIColor blackColor];
    self.separatorInset = UIEdgeInsetsMake(0, 100.0, 0, 0);
    [_taskCircleView removeFromSuperview];
    
    self.event = nil;
    [self setNeedsDisplay];
    
}


- (NSString *)dateFormater:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:16]];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
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

- (void)initTaskCircleWithLine {
    
}

@end
