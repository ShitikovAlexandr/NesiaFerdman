//
//  NFStatisticController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticController.h"
#import "NFValuesFilterView.h"
#import "NFStatisticMainCell.h"
#import "NFStyleKit.h"
#import "NFStatisticDetailController.h"
#import "NFResultCategory.h"
#import "NFSettingManager.h"


@interface NFStatisticController () <UITableViewDelegate, UITableViewDataSource, JTCalendarDelegate>
{
    NSMutableDictionary *_eventsByDate;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
}
@property (weak, nonatomic) IBOutlet NFValuesFilterView *filtrView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonnull) NSMutableDictionary *dataDictionary;

@property (weak, nonatomic) IBOutlet UIButton *leftScroll;
@property (weak, nonatomic) IBOutlet UIButton *rightScroll;
@property (weak, nonatomic) IBOutlet UIView *headerMainView;


@end

@implementation NFStatisticController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataDictionary = [NSMutableDictionary dictionary];
    self.title = @"Статистика";
    [self addNavigationButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFStatisticMainCell" bundle:nil] forCellReuseIdentifier:@"NFStatisticMainCell"];
    self.tableView.tableFooterView = [UIView new];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    [NFStyleKit drawDownBorderWithView:self.headerMainView];
    self.headerMainView.backgroundColor = [NFStyleKit _base_GREY];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_filtrView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    [self reloadEventsDataWithDate:_calendarManager.date ? _calendarManager.date : _todayDate];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([NFTaskManager sharedManager].selectedValuesArray.count) {
        return [NFTaskManager sharedManager].selectedValuesArray.count;
    } else {
        return [[NFTaskManager sharedManager] getAllValues].count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFStatisticMainCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"NFStatisticMainCell"];
    [cell addDatatoCellwithDictionary:_dataDictionary indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self navigateToMonthDitailScreenWithIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190.0;
}

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    NSLog(@"Next page loaded %@", _calendarManager.date);
    [self reloadEventsDataWithDate:_calendarManager.date];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSLog(@"Previous page loaded %@", _calendarManager.date);
    [self reloadEventsDataWithDate:_calendarManager.date];
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
    menuItemView.text = [dateFormatter stringFromDate:date].uppercaseString;
}


- (IBAction)scrollCalendarAction:(UIButton*)sender {
    if (sender.tag == 1) {
        [self.calendarContentView loadPreviousPageWithAnimation];
    } else if (sender.tag == 2) {
        [self.calendarContentView loadNextPageWithAnimation];
    }
}

#pragma mark - Helpers

- (void)reloadEventsDataWithDate:(NSDate*)selectedDate {
    [self.dataDictionary removeAllObjects];
    NSMutableArray* eventsArray = [NSMutableArray array];
    [eventsArray addObjectsFromArray: [[NFTaskManager sharedManager] getTaskForMonth:selectedDate]];
    [self.dataDictionary setDictionary:[[NFTaskManager sharedManager] eventSortedByValue:eventsArray]];
    [self.tableView reloadData];
}

- (void)addNavigationButton {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_standart"] style:UIBarButtonItemStylePlain target:self action:@selector(exitAction)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)exitAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

- (void)navigateToMonthDitailScreenWithIndexPath:(NSIndexPath*)indexPath {
    NFStatisticMainCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NFStatisticDetailController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticDetailController"];
        viewController.selectedDate = _calendarManager.date ? _calendarManager.date : _todayDate;
        viewController.value = cell.value;
        [self presentViewController:viewController animated:YES completion:nil];
    }


@end
