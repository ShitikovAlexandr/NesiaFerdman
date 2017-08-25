//
//  NFTCalendarListCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/19/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFGoogleCalendar.h"

@interface NFTCalendarListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *calendarSwitcher;

- (void)addDataToCell:(NFGoogleCalendar *)calendar;

@end
