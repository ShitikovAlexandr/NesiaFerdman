//
//  NFResultDayController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/7/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultDayController.h"
#import "NFHeaderView.h"
#import "NFResultMenuCell.h"
#import "NFResultDetailController.h"
#import "NFTaskManager.h"
#import "NFDateModel.h"
#import "NFSettingManager.h"
#import "NotifyList.h"
#import "UIBarButtonItem+FHButtons.h"

@interface NFResultDayController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation NFResultDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Итоги";
    _dataArray = [NSMutableArray array];
    _tableView.tableFooterView = [UIView new];
    NFDateModel *dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                             endDate:[NFSettingManager getMaxDate]];
    [self.headerView addNFDateModel:dateLimits weeks:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataToDisplay) name:HEADER_NOTIF object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_NOTIF object:nil];
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
    [cell addDataToDayCell:category date:self.headerView.selectetDate];
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

- (void)navigateToDetailCategory:(NFResultCategory*)category {
    NFResultDetailController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailController"];
    viewController.week = [self.headerView.dateSourse.weekArray objectAtIndex:_headerView.selectedIndex];
    viewController.selectedCategory = category;
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailControllerNav"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
