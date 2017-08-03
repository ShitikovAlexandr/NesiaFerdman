//
//  NFResultDetailController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultDetailController.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFEditResultController.h"
#import "NFResultCell.h"
#import "NFHeaderForTaskSection.h"
#import "NFDataSourceManager.h"

@interface NFResultDetailController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDate *dateForNewItem;
@end

@implementation NFResultDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.title = self.selectedCategory.title;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewItem)];
    self.navigationItem.rightBarButtonItem = item;

    self.tableView.tableFooterView = [UIView new];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (eventCell.event) {
        [self navigateToEditScreenWithItem:eventCell.event];
    } else {
        [self createNewItem];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        return [NFHeaderForTaskSection headerSize];
    } else {
        return 0.0001;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.view removeGestureRecognizer:[[UIGestureRecognizer alloc] init]];
    if (self.dataArray.count > 0) {
        NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
        [headerView.iconImage setImage:[UIImage imageNamed:@"task_section_icon.png"]];
        NSArray *eventDayArray = [_dataArray objectAtIndex:section];
        NFNRsult *event = [eventDayArray firstObject];
        [headerView setCurrentDate:[self stringDate:event.createDate withFormat:@"yyyy-MM-dd"]];
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] init];
        return headerView;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count > 0 ? _dataArray.count : 1;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = _dataArray.count > 0 ? [self.dataArray objectAtIndex:section] : [NSArray array];
    return sectionData.count > 0 ? sectionData.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NFResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (self.dataArray.count > 0) {
        NSArray *eventDayArray = [_dataArray objectAtIndex:indexPath.section];
        NFNRsult *event = [eventDayArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        [cell addData:nil];
    }
    return cell;
}

#pragma mark - helpers

- (void)addDataToDisplay {
    [self.dataArray removeAllObjects];
    if (_week) {
        _dateForNewItem = [_week.allDateOfWeek firstObject];
        NFWeekDateModel *week = _week;
        for (NSDate *dayDate in week.allDateOfWeek) {
            [self.dataArray addObjectsFromArray:[self getResultForDay:dayDate]];
        }
    } else if (_selectedDate) {
        _dateForNewItem = _selectedDate;
         [self.dataArray addObjectsFromArray:[self getResultForDay:_selectedDate]];
    } else if (_monthDate) {
        _dateForNewItem = [self getFirsDayOfMonthWithDate:_monthDate];
        NSLog(@"select month detail");
        [_dataArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getResultWithFilter:_selectedCategory forMonth:_monthDate]];
    }
    [self.tableView reloadData];
 }

- (NSMutableArray*)getResultForDay:(NSDate*)day {
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *dayArray = [NSMutableArray array];
    [dayArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getResultWithFilter:_selectedCategory forDay:day]];
    if (dayArray.count > 0) {
        [result addObject:dayArray];
    }
    return result;
}

- (void)navigateToEditScreenWithItem:(NFNRsult*)result {
    NFEditResultController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFEditResultController"];
    viewController.category = self.selectedCategory;
    viewController.resultItem = result;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSDate *)stringDate:(NSString *)stringInput
            withFormat:(NSString *)inputFormat {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    return dateFromString;
}

- (void)createNewItem {
 NFEditResultController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFEditResultController"];
    viewController.category = self.selectedCategory;
    viewController.resultItem = nil;
    viewController.selectedDate = _dateForNewItem;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSDate*)getFirsDayOfMonthWithDate:(NSDate*)currentDate {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:currentDate];
    components.day = 2;
    NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: components];
    return firstDayOfMonthDate;
}

@end
