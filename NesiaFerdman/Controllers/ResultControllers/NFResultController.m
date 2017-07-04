//
//  NFResultController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultController.h"
#import "NotifyList.h"
#import "NFTaskManager.h"
#import "NFResultCategory.h"
#import "NFResultDetailController.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFWeekDateModel.h"
#import "NFSettingManager.h"
#import "NFResultMenuCell.h"



@interface NFResultController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation NFResultController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addNavigationButton];
    self.title = @"Итоги";
    self.tableView.tableFooterView = [UIView new];
    self.dataArray = [NSMutableArray array];
//    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
//    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
    NFDateModel *dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                             endDate:[NFSettingManager getMaxDate]];
    [self.headerView addNFDateModel:dateLimits weeks:YES];
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];

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
     NSString *const identifier = @"Cell";
    
    NFResultMenuCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NFResultMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NFResultCategory *category = [_dataArray objectAtIndex:indexPath.row];
    [cell addDataToCell:category date:[self.headerView.dateSourse.weekArray objectAtIndex:_headerView.selectedIndex]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultCategory *category = [_dataArray objectAtIndex:indexPath.row];
    [self navigateToDitailCategory:category];
}

#pragma mark - Helpers

- (void) addDataToDisplay {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getAllResultCategory]];
    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)addNavigationButton {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_standart"] style:UIBarButtonItemStylePlain target:self action:@selector(exitAction)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)exitAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigateToDitailCategory:(NFResultCategory*)category {
    NFResultDetailController *viewCotroller = [self.storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailController"];
    viewCotroller.week = [self.headerView.dateSourse.weekArray objectAtIndex:_headerView.selectedIndex];
    viewCotroller.selectedCategory = category;
    [self.navigationController pushViewController:viewCotroller animated:YES];
}

@end
