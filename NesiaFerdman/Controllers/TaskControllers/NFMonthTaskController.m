//  NFMonthTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//
#define GREEN_COLOR [UIColor colorWithRed:43/255.0 green:154/255.0 blue:63/255.0 alpha:1]
#define LIGHT_GREEN_COLOR [UIColor colorWithRed:43/255.0 green:154/255.0 blue:63/255.0 alpha:0.5]


#import "NFMonthTaskController.h"
#import "NFHeaderForTaskSection.h"
#import "NFTaskManager.h"
#import "NFEvent.h"
#import "NFTaskSimpleCell.h"
#import "NFPickerView.h"
#import "NFStyleKit.h"
#import "NFValuesFilterView.h"
#import "NFSettingManager.h"


@interface NFMonthTaskController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSMutableDictionary *_eventsByDate;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *leftScroll;
@property (weak, nonatomic) IBOutlet UIButton *rightScroll;
@property (weak, nonatomic) IBOutlet UIView *headerMainView;
@property (weak, nonatomic) IBOutlet UITextField *filterTextField;

@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NFPickerView *valuePicker;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *ValuesFilterView;

@end

@implementation NFMonthTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.58)];

    
    [_ValuesFilterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    _valuesArray = [NSMutableArray arrayWithArray:[[NFTaskManager sharedManager] getAllValues]];
    self.filterTextField.text = ((NFValue*)([_valuesArray firstObject])).valueTitle;
    _valuePicker = [[NFPickerView alloc] initWithDataArray:_valuesArray textField:_filterTextField   keyTitle:@"valueTitle"];
    self.tableView.tableFooterView = [UIView new];
    
//    [NFStyleKit drawDownBorderWithView:self.headerMainView];
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"NFTaskSimpleCell" bundle:nil] forCellReuseIdentifier:@"NFTaskSimpleCell"];
//    self.headerMainView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1];
    self.dataArray = [NSMutableArray array];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    //_eventsByDate = [NFTaskManager sharedManager].eventTaskDictionary;
    
    
    [self createMinAndMaxDate];
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    [_calendarManager.dateHelper.calendar setFirstWeekday:1];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    
    [self setEventsToTableViewWithCurrentDate:_dateSelected ? _dateSelected: _todayDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
    [_ValuesFilterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    [self setEventsToTableViewWithCurrentDate:_dateSelected ? _dateSelected: _todayDate];
}

- (void)addDataToDisplay {
//    [_eventsByDate removeAllObjects];
    _eventsByDate = [NSMutableDictionary dictionary];

    _eventsByDate = [[NFTaskManager sharedManager] getAllTaskDictionaryWithFilter];
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
    [self setEventsToTableViewWithCurrentDate:dayView.date];
    
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
    
    // Min date will be 2 month before today
    //_minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    _minDate = [NFSettingManager getMinDate];
    
    // Max date will be 2 month after today
    //_maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:24];
    _maxDate = [NFSettingManager getMaxDate];
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
        //self.calendarMenuView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1];
    }
//    CATransition *animation = [CATransition animation];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.type = kCATransitionFade;
//    animation.duration = 0.75;
//    [menuItemView.layer addAnimation:animation forKey:@"kCATransitionFade"];
    menuItemView.text = [dateFormatter stringFromDate:date].uppercaseString;
}

//- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
//{
//    UILabel *label = [UILabel new];
//
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont fontWithName:@"Avenir-Medium" size:18];
//
//    return label;
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        if (_dataArray.count > 0) {
            return _dataArray.count;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NFTaskSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFTaskSimpleCell"];
    if (!cell) {
        cell = [[NFTaskSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NFTaskSimpleCell"];
    }
    
    if (self.dataArray.count > 0) {
        NFEvent *event = [self.dataArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        [cell addData:nil];
    }
    cell.editing = YES;
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
               return self.calendarContentView;
        
    } else {
        NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
        [headerView.iconImage setImage:[UIImage imageNamed:@"List_Document@2x.png"]];
        [headerView setCurrentDate:_dateSelected?_dateSelected:_todayDate];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.view.frame.size.height * 0.58;
    } else {
        return [NFHeaderForTaskSection headerSize];

    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskSimpleCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditTaskScreenWithEvent:eventCell.event];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSLog(@"delete");
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 36.0;
}

//- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 1)  {
//        return UITableViewCellEditingStyleDelete;
//    }
//
//    else {
//        return UITableViewCellEditingStyleNone;
//
//    }
//}


//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}

#pragma mark - Helpers

- (void)setEventsToTableViewWithCurrentDate:(NSDate *)date {
    [self.dataArray removeAllObjects];
    self.dataArray = [[NFTaskManager sharedManager] getTasksForDay:date];
    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}


- (IBAction)scrollCalendarAction:(UIButton*)sender {
    if (sender.tag == 1) {
        [self.calendarContentView loadPreviousPageWithAnimation];
    } else if (sender.tag == 2) {
        [self.calendarContentView loadNextPageWithAnimation];
    }
}

@end
