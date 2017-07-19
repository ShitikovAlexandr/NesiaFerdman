//
//  NFTCalendarListCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/19/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTCalendarListCell.h"
#import "NFSyncManager.h"

@interface NFTCalendarListCell ()
@property (weak, nonatomic) IBOutlet UILabel *calendarTitleLabel;
@property (strong, nonatomic) NFGoogleCalendar *calendar;

@end

@implementation NFTCalendarListCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addDataToCell:(NFGoogleCalendar *)calendar {
    _calendarTitleLabel.text = calendar.summary;
    [_calendarSwitcher setOn:calendar.selectedInApp];
    _calendar = calendar;
}

- (void)prepareForReuse {
    _calendarTitleLabel.text = @"";
    _calendar = nil;
    [_calendarSwitcher setOn:false];
}


@end
