//
//  NFMonthConclusionsController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/15/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFMonthConclusionsController.h"
#import "NFHeaderForTaskSection.h"
#import "NFTaskManager.h"
#import "NFEvent.h"
#import "NFTaskSimpleCell.h"
#import <STCollapseTableView.h>
#import "NotifyList.h"
#import "NFStyleKit.h"

@interface NFMonthConclusionsController ()  <UITableViewDelegate, UITableViewDataSource>

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

@implementation NFMonthConclusionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
        
//    [self.tableView registerNib:[UINib nibWithNibName:@"NFTaskSimpleCell" bundle:nil] forCellReuseIdentifier:@"NFTaskSimpleCell"];
    self.dataArray = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsSelection = YES;
    
    // Do any additional setup after loading the view.
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    //    [self createRandomEvents];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSendLongTouch) name:LONG_CELL_PRESS object:nil];
    [self addDataToDisplay:_calendarManager.date ? _calendarManager.date : _todayDate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LONG_CELL_PRESS object:nil];
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
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSLog(@"Previous page loaded %@", _calendarManager.date);
    [self addDataToDisplay:_calendarManager.date];
    
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:24];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
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
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
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
    
    NSLog(@"section count %lu", (unsigned long)(_dataArray.count > 0 ? _dataArray.count : 1));
    return  _dataArray.count > 0 ? _dataArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = _dataArray.count > 0 ? [self.dataArray objectAtIndex:section] : nil;
    
    NSLog(@"numberOfRows %lu InSection %ld", (unsigned long)(sectionData.count > 0 ? sectionData.count : 1), (long)section);
    
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
        cell.textLabel.text = @"Нет задач";
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView.editing) {
        [tableView setEditing:NO animated:YES];
    } else {
        NSLog(@"go to detail screen");
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"input indexPath %@", indexPath);
        [self.tableView beginUpdates];
        
        [[_dataArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        
        if ([[_dataArray objectAtIndex:indexPath.section] count] > 0) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            
            [_dataArray removeObjectAtIndex:indexPath.section];
            
            if (_dataArray.count > 0) {
                //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            NSLog(@"table view %@", self.tableView);
        }
        NSLog(@"modigy indexPath %@", indexPath);
        [self.tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView setEditing:NO animated:YES];
        });
        
    } else {
        NSLog(@"else");
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Helpers

- (NSDate *)stringDate:(NSString *)stringInput
            withFormat:(NSString *)inputFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    NSLog(@"new date %@", dateFromString);
    return dateFromString;
}

- (void)addDataToDisplay:(NSDate *)currentDate {
    [self.dataArray removeAllObjects];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:[[NFTaskManager sharedManager] getConclusionsForMonth:currentDate]];
    if (tempArray.count > 0) {
        for (NSArray* arr in tempArray) {
            if (arr.count > 0) {
                [self.dataArray addObject:arr];
            }
        }
    }
    
    //[self.dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getImportantForMonth:currentDate]];
    NSLog(@"input date %@", [[NFTaskManager sharedManager] getImportantForMonth:currentDate]);
    [_tableView setEditing:NO animated:YES];
    [self.tableView reloadData];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationTop];
}

- (void)cellSendLongTouch {
    if (_dataArray.count > 0 && !_tableView.editing) {
        [_tableView setEditing:YES animated:YES];
        NSLog(@"edit");
    }
}

@end
