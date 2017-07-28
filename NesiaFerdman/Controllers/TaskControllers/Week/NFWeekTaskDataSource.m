//
//  NFWeekTaskDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFWeekTaskDataSource.h"
#import "NFSettingManager.h"
#import "NFDataSourceManager.h"
//#import "NFTaskSimpleCell.h"
#import "NFTaskCellDescription.h"

#import "NFHeaderForTaskSection.h"
#import "NFNEvent.h"
#import "NFEditTaskController.h"

@interface NFWeekTaskDataSource () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIViewController *target;
@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) NFDateModel *dateLimits;
@property (strong, nonatomic) NFWeekDateModel *selectedDate;
@property (strong, nonatomic) NSMutableArray *keyArray;
@end

@implementation NFWeekTaskDataSource
- (instancetype)initWithTableView:(UITableView*)tableview target:(id)target {
    self = [super init];
    if (self) {
        _tableView = tableview;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _target = target;
        _eventsArray = [NSMutableArray array];
        _keyArray = [NSMutableArray array];
        _dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                     endDate:[NFSettingManager getMaxDate]];
        [self.tableView registerNib:[UINib nibWithNibName:@"NFTaskCellDescription" bundle:nil] forCellReuseIdentifier:@"NFTaskCellDescription"];
    }
    return self;
}

- (NFDateModel*)getDateLimits {
    return _dateLimits;
}

- (void)setSelectedDate:(NFWeekDateModel*)date {
    _selectedDate = date;
    [self getData];
}

- (void)getData {
    [self.eventsArray removeAllObjects];
    for (NSDate *dayDate in _selectedDate.allDateOfWeek) {
        NSMutableArray *dayArray = [NSMutableArray array];
        dayArray = [[NFDataSourceManager sharedManager] getEventForDay:dayDate];
        if (dayArray.count > 0) {
            [self.eventsArray addObject:dayArray];
            [self.keyArray addObject:dayDate];
        }
    }
    [self.tableView reloadData];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationTop];
}

- (NSArray*)setValueFilterData {
    return [[NFDataSourceManager sharedManager] getSelectedValueList];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _eventsArray.count > 0 ? _eventsArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = _eventsArray.count > 0 ? [_eventsArray objectAtIndex:section] : [NSArray array];
    return sectionData.count > 0 ? sectionData.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskCellDescription *cell = [tableView dequeueReusableCellWithIdentifier:@"NFTaskCellDescription"];
    if (_eventsArray.count > 0) {
        NSArray *eventDayArray = [_eventsArray objectAtIndex:indexPath.section];
        NFNEvent *event = [eventDayArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        [cell addData:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NFTaskCellDescription cellSize];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_eventsArray.count > 0) {
        return [NFHeaderForTaskSection headerSize];
    } else {
        return 0.0001;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_eventsArray.count > 0) {
        NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, _target.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
            NSArray *eventDayArray = [_eventsArray objectAtIndex:section];
            [headerView setTaskCount:eventDayArray];
            if ([[_keyArray objectAtIndex:section] isKindOfClass:[NSDate class]]) {
                [headerView setCurrentDate:[_keyArray objectAtIndex:section]];
            }
        return headerView;
         }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskCellDescription* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditTaskScreenWithEvent:eventCell.event];
}

#pragma mark - Helpers

- (NSDate *)stringDate:(NSString *)stringInput
            withFormat:(NSString *)inputFormat {
    
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    return dateFromString;
}

#pragma mark - navigation

- (void)navigateToEditTaskScreenWithEvent:(NFNEvent*)event {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NFEditTaskController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFEditTaskController"];
    viewController.event = event;
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFEditTaskNavController"];
    [navController setViewControllers:@[viewController]];
    [_target presentViewController:navController animated:YES completion:nil];
}

@end
