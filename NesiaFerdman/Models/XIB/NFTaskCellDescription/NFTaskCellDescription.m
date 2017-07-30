//
//  NFTaskCellDescription.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/28/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTaskCellDescription.h"
#import "NFStyleKit.h"

@interface NFTaskCellDescription ()
@property (weak, nonatomic) IBOutlet UIImageView *chackboxImj;
@property (weak, nonatomic) IBOutlet UILabel *titleTaskLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *calendarColorView;
@end

@implementation NFTaskCellDescription

- (void)awakeFromNib {
    [super awakeFromNib];
    _calendarColorView.backgroundColor  = [UIColor clearColor];
}

+ (CGFloat)cellSize {
    return 60.0;
}
    


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)addData:(NFNEvent*)event {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (event) {
        self.event = event;
        self.calendarColorView.backgroundColor = [NFStyleKit colorFromHexString:event.calendarColor];
        self.titleTaskLabel.text = event.title;
        self.timeLabel.text = [self getTimeStringFromEvent:_event];
        [self.timeLabel sizeToFit];
        
        if (event.eventType == Event) {
            if (event.isDone) {
                [self.chackboxImj setImage:[UIImage imageNamed:@"checked_enable.png"]];
            } else {
                [self.chackboxImj setImage:[UIImage imageNamed:@"checked_disable.png"]];
            }
        } else {
            [self.chackboxImj setImage:[UIImage imageNamed:@"point.png"]];
        }
    } else {
        self.titleTaskLabel.text = @"Добавить";
        [self.chackboxImj setImage:[UIImage imageNamed:@"Add.png"]];
    }
}

- (void)prepareForReuse {
    self.titleTaskLabel.text = @"";
    [self.chackboxImj setImage:nil];
    self.event = nil;
    self.calendarColorView.backgroundColor = [UIColor clearColor];
    self.timeLabel.text = @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageDiametr = 17.f;
    self.imageView.frame = CGRectMake(19, self.imageView.center.y - imageDiametr/2, imageDiametr , imageDiametr);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
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


- (NSString*)getTimeStringFromEvent:(NFNEvent*)event {
    NSString *result = @"";
    NSDate *start = [self datefromString:event.startDate];
    NSDate *end = [self datefromString:event.endDate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if (![calendar isDate:[self dateWithNoTime:start] inSameDayAsDate:[self dateWithNoTime:end]]) {
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
    [dateFormatter1 setDateFormat:@"d MMMM yyyy\tHH:mm"];
    NSString* newDate = [dateFormatter1 stringFromDate:date];
    return newDate;
}




@end
