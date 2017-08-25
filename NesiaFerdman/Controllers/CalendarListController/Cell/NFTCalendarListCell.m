//
//  NFTCalendarListCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/19/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTCalendarListCell.h"
#import "NFStyleKit.h"
@interface NFTCalendarListCell ()
@property (weak, nonatomic) IBOutlet UILabel *calendarTitleLabel;
@property (strong, nonatomic) NFGoogleCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIView *calendarColorView;

@end

@implementation NFTCalendarListCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addDataToCell:(NFGoogleCalendar *)calendar {
    _calendarTitleLabel.text = calendar.summary;
    [_calendarSwitcher setOn:calendar.selectedInApp];
    _calendar = calendar;
    _calendarColorView.backgroundColor = [NFStyleKit colorFromHexString:calendar.backgroundColor];
}

- (void)prepareForReuse {
    _calendarTitleLabel.text = @"";
    _calendar = nil;
    [_calendarSwitcher setOn:false];
}


@end
