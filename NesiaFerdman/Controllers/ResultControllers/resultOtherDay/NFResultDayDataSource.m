//
//  NFResultDayDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultDayDataSource.h"
#import "NFResultMenuCell.h"
#import "NFTaskManager.h"
#import "NFSettingManager.h"
#import "NFResultDetailController.h"

@interface NFResultDayDataSource() <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NFDateModel *dateLimits;
@property (strong, nonatomic) id target;
@end

@implementation NFResultDayDataSource

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target {
    self = [super init];
    if (self) {
        _target = target;
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _dataArray = [NSMutableArray new];
        _dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                    endDate:[NFSettingManager getMaxDate]];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultMenuCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NFResultMenuCell alloc] initWithDefaultStyle];
    }
    NFResultCategory *category = [_dataArray objectAtIndex:indexPath.row];
    [cell addDataToDayCell:category date:_selectedDate];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultCategory *category = [_dataArray objectAtIndex:indexPath.row];
    [self navigateToDetailCategory:category];
}

#pragma mark - Helpers

- (void) addDataToDisplay {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getAllResultCategory]];
    [self.tableView reloadData];
}

- (void)setSelectedDate:(NSDate*)date {
    _selectedDate = date;
    [self addDataToDisplay];
}

- (NFDateModel*)getDateLimits {
    return _dateLimits;
}

#pragma mark - Navigation

- (void)navigateToDetailCategory:(NFResultCategory*)category {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NFResultDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailController"];
    viewController.selectedDate = _selectedDate;
    viewController.selectedCategory = category;
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailControllerNav"];
    [navController setViewControllers:@[viewController]];
    [_target presentViewController:navController animated:YES completion:nil];
}

@end
