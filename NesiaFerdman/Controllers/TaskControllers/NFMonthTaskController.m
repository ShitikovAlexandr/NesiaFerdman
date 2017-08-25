//  NFMonthTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//
#define GREEN_COLOR [UIColor colorWithRed:43/255.0 green:154/255.0 blue:63/255.0 alpha:1]
#define LIGHT_GREEN_COLOR [UIColor colorWithRed:43/255.0 green:154/255.0 blue:63/255.0 alpha:0.5]

#import "NFMonthTaskController.h"
#import "NFHeaderForTaskSection.h"
#import "NFTaskSimpleCell.h"
#import "NFValuesFilterView.h"
#import "NFMonthTaskDataSource.h"
#import "NFDataSourceManager.h"

@interface NFMonthTaskController ()
{
    NSMutableDictionary *_eventsByDate;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *leftScroll;
@property (weak, nonatomic) IBOutlet UIButton *rightScroll;
@property (weak, nonatomic) IBOutlet UIView *headerMainView;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *ValuesFilterView;
@property (strong, nonatomic) NFMonthTaskDataSource *dataSource;
@end

@implementation NFMonthTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.58)];
    _dataSource = [[NFMonthTaskDataSource alloc] initWithTableView:_tableView
                                                            target:self
                                                      calendarView:_calendarContentView];
    
    [_ValuesFilterView updateTitleFromArray:[_dataSource setValueFilter]];
    self.tableView.tableFooterView = [UIView new];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [self createMinAndMaxDate];
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    [_calendarManager.dateHelper.calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [_calendarManager.dateHelper.calendar setFirstWeekday:1];
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    [_dataSource setSelectedDate:_dateSelected ? _dateSelected: _todayDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:END_UPDATE_DATA_SOURCE object:nil];

    [self addDataToDisplay];
    [_ValuesFilterView updateTitleFromArray:[_dataSource setValueFilter]];
    [_dataSource setSelectedDate:_dateSelected ? _dateSelected: _todayDate];
}

- (void)updateData {
    //[_ValuesFilterView updateTitleFromArray:[_dataSource setValueFilter]];
    [_dataSource setSelectedDate:_dateSelected ? _dateSelected: _todayDate];
    [_calendarManager reload];
}

- (void)addDataToDisplay {
    _eventsByDate = [NSMutableDictionary dictionary];

    _eventsByDate = [_dataSource setEventDictionary];
    [_calendarManager reload];
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

#pragma mark - CalendarManager delegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.textLabel.font = [UIFont systemFontOfSize:14.f];
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = LIGHT_GREEN_COLOR;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = GREEN_COLOR;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = LIGHT_GREEN_COLOR;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = GREEN_COLOR;
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    [_dataSource setSelectedDate:dayView.date];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement
// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    _minDate = [_dataSource setMinDate];
    _maxDate = [_dataSource setMaxDate];
}

// Used only to have a key for _eventsByDate
- (NFDateFormatter *)dateFormatter
{
    static NFDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NFDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NFDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NFDateFormatter new];
        dateFormatter.dateFormat = @"LLLL yyyy";
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    menuItemView.text = [[dateFormatter stringFromDate:date] uppercaseString];
}

#pragma mark - Helpers

- (IBAction)scrollCalendarAction:(UIButton*)sender {
    if (sender.tag == 1) {
        [self.calendarManager.contentView loadPreviousPageWithAnimation];
    } else if (sender.tag == 2) {
        [self.calendarManager.contentView loadNextPageWithAnimation];
    }
}

@end
