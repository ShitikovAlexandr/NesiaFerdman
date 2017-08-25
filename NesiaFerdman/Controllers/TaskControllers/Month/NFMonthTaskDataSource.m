//
//  NFMonthTaskDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/28/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFMonthTaskDataSource.h"
#import "NFNEvent.h"
#import "NFTaskCellDescription.h"
#import "NFHeaderForTaskSection.h"
#import "NFEditTaskController.h"
#import "NFDataSourceManager.h"
#import "NFSettingManager.h"

@interface NFMonthTaskDataSource() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSDate* selectedDate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIViewController *target;
@property (strong, nonatomic) id calendarView;
@end

@implementation NFMonthTaskDataSource

- (instancetype)initWithTableView:(UITableView*)tableView
                           target:(id)target
                     calendarView:(id)calendarView {
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _target = target;
        _calendarView = calendarView;
        [_tableView registerNib:[UINib nibWithNibName:@"NFTaskCellDescription" bundle:nil] forCellReuseIdentifier:@"NFTaskCellDescription"];
    }
    return self;
}

- (NSArray*)setValueFilter {
    return [[NFDataSourceManager sharedManager] getSelectedValueList];
}

- (NSDate*)setMinDate {
    return [NFSettingManager getMinDate];
}

- (NSDate*)setMaxDate {
    return [NFSettingManager getMaxDate];
}

- (NSMutableDictionary*)setEventDictionary {
    return [[NFDataSourceManager sharedManager] getAllEventsDictionaryWithFilter];
}

- (void)getData {
    [self.dataArray removeAllObjects];
    self.dataArray = [[NFDataSourceManager sharedManager] getEventForDay:_selectedDate];
    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)setSelectedDate:(NSDate*)date {
    _selectedDate = date;
    [self getData];
}

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
    
    NFTaskCellDescription *cell = [tableView dequeueReusableCellWithIdentifier:@"NFTaskCellDescription"];
    if (_dataArray.count > 0) {
        NFNEvent *event = [_dataArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        [cell addData:nil];
    }
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _calendarView;
    } else {
        NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, _target.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
        if (_dataArray.count > 0) {
            [headerView setTaskCount:_dataArray];
            [headerView setCurrentDate:_selectedDate];
            return headerView;
        }
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _target.view.frame.size.height * 0.58;
    } else {
        return [NFHeaderForTaskSection headerSize];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskCellDescription* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditTaskScreenWithEvent:eventCell.event];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NFTaskCellDescription cellSize];
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
