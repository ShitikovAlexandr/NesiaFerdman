//
//  NFResultWeekDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultWeekDataSource.h"
#import "NFResultMenuCell.h"
#import "NFSettingManager.h"
#import "NFDataSourceManager.h"
#import "NFResultDetailController.h"

@interface NFResultWeekDataSource() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NFDateModel *dateLimits;
@property (strong, nonatomic) NFWeekDateModel *selectedWeek;
@property (strong, nonatomic) id target;

@end

@implementation NFResultWeekDataSource

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target {
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
        _target = target;
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    NFNRsultCategory *category = [_dataArray objectAtIndex:indexPath.row];
    [cell addDataToCell:category date:_selectedWeek];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFNRsultCategory *category = [_dataArray objectAtIndex:indexPath.row];
    [self navigateToDitailCategory:category];
}

#pragma mark - Helpers

- (void) addDataToDisplay {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getResultCategoryList]];
    [self.tableView reloadData];
}

- (NFDateModel*)getDateLimits {
    return  _dateLimits;
}

- (void)setSelectedDate:(NFWeekDateModel*)week {
    _selectedWeek = week;
    [self addDataToDisplay];
}

#pragma mark - Navigation

- (void)navigateToDitailCategory:(NFNRsultCategory*)category {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NFResultDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailController"];
    viewController.week = _selectedWeek;
    viewController.selectedCategory = category;
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailControllerNav"];
    [navController setViewControllers:@[viewController]];
    [_target presentViewController:navController animated:YES completion:nil];
}

@end
