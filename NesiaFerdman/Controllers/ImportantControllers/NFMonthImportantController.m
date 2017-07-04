//
//  NFMonthImportantController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFMonthImportantController.h"
#import "NFHeaderForTaskSection.h"
#import "NFTaskManager.h"
#import "NFEvent.h"
#import "NFTaskSimpleCell.h"
#import <STCollapseTableView.h>
#import "NotifyList.h"
#import "NFStyleKit.h"
#import "NFTAddImportantTaskTableViewController.h"
#import "NFSettingManager.h"

@interface NFMonthImportantController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

{
    NSMutableDictionary *_eventsByDate;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
}

@property (weak, nonatomic) IBOutlet STCollapseTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *leftScroll;
@property (weak, nonatomic) IBOutlet UIButton *rightScroll;
@property (weak, nonatomic) IBOutlet UIView *headerMainView;
@end

@implementation NFMonthImportantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    
    self.dataArray = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _eventsByDate = [NSMutableDictionary dictionary];
    _eventsByDate = [NFTaskManager sharedManager].eventImportantDictionary;
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay:_calendarManager.date ? _calendarManager.date : _todayDate];
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    NSLog(@"Next page loaded %@", _calendarManager.date);
    [self addDataToDisplay:_calendarManager.date];
    NSLog(@"_calendarManager.date %@", _calendarManager.date);
    
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSLog(@"Previous page loaded %@", _calendarManager.date);
    [self addDataToDisplay:_calendarManager.date];
    NSLog(@"_calendarManager.date %@", _calendarManager.date);
    
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
    menuItemView.text = [dateFormatter stringFromDate:date].uppercaseString;
}

- (IBAction)scrollCalendarAction:(UIButton*)sender {
    if (sender.tag == 1) {
        [self.calendarContentView loadPreviousPageWithAnimation];
    } else if (sender.tag == 2) {
        [self.calendarContentView loadNextPageWithAnimation];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  _dataArray.count > 0 ? _dataArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = _dataArray.count > 0 ? [self.dataArray objectAtIndex:section] : [NSArray array];
    return sectionData.count > 0 ? sectionData.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NFTaskSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (self.dataArray.count > 0) {
        NSArray *eventDayArray = [_dataArray objectAtIndex:indexPath.section];
        NFEvent *event = [eventDayArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        [cell addData:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        return [NFHeaderForTaskSection headerSize];
    } else {
        return 1.f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
        NSArray *eventDayArray = [_dataArray objectAtIndex:section];
        NFEvent *event = [eventDayArray firstObject];
        [headerView setCurrentDate:[self stringDate:event.startDate withFormat:@"yyyy-MM-dd"]];
        [headerView setTaskCount:eventDayArray];
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] init];
        return headerView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskSimpleCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditTaskScreenWithEvent:eventCell.event];
}

#pragma mark - Helpers

- (NSDate *)stringDate:(NSString *)stringInput
            withFormat:(NSString *)inputFormat {
    
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    NSLog(@"new date %@", dateFromString);
    return dateFromString;
}

- (void)addDataToDisplay:(NSDate *)currentDate {
    [self.dataArray removeAllObjects];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:[[NFTaskManager sharedManager] getImportantForMonth:currentDate]];
    if (tempArray.count > 0) {
        for (NSArray* arr in tempArray) {
            if (arr.count > 0) {
                [self.dataArray addObject:arr];
            }
        }
    }
    [self.tableView reloadData];
    [self.tableView openSection:0 animated:NO];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationTop];
}

- (void)navigateToEditTaskScreenWithEvent:(NFEvent*)event {
    NFTAddImportantTaskTableViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NFTAddImportantTaskTableViewController"];
    addVC.event = event;
    addVC.eventType = Important;
    UINavigationController *navVCB = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavViewController"];
    navVCB.navigationBar.barStyle = UIBarStyleBlack;
    [navVCB setViewControllers:@[addVC] animated:YES];
    [self presentViewController:navVCB animated:YES completion:nil];
}

@end
