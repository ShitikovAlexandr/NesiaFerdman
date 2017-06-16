//
//  NFMonthImportantController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFViewController.h"
#import <JTCalendar/JTCalendar.h>


@interface NFMonthImportantController : NFViewController <JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;



@end
