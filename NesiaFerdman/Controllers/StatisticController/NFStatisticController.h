//
//  NFStatisticController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFViewController.h"
#import <JTCalendar/JTCalendar.h>


@interface NFStatisticController : NFViewController

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;


@end
