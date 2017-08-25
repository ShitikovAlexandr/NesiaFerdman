//
//  NFResultMonthDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultMonthDataSource.h"
#import "NFSettingManager.h"
#import "NFResultMenuCell.h"
#import "NFResultDetailController.h"
#import "NFDataSourceManager.h"

@interface NFResultMonthDataSource() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) id target;

@end

@implementation NFResultMonthDataSource

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target {
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
        _target = target;
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    [cell addDataToMonthCell:category date:_selectedDate];
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

- (void)setSelectedDate:(NSDate*)date {
    _selectedDate = date;
    [self addDataToDisplay];
}

#pragma mark - Navigation

- (void)navigateToDitailCategory:(NFNRsultCategory*)category {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NFResultDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailController"];
    viewController.monthDate = _selectedDate;
    viewController.selectedCategory = category;
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailControllerNav"];
    [navController setViewControllers:@[viewController]];
    [_target presentViewController:navController animated:YES completion:nil];
    
}





@end
