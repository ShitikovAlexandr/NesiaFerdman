//
//  NFStatisticWeekController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticWeekController.h"
#import "NFHeaderView.h"
#import "NFValuesFilterView.h"
#import "NFStatisticWeekDataSource.h"
#import "NotifyList.h"
#import "NFTaskManager.h"

@interface NFStatisticWeekController ()
@property (weak, nonatomic) IBOutlet NFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *filterView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFStatisticWeekDataSource *dataSource;
@end

@implementation NFStatisticWeekController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NFStatisticWeekDataSource alloc] initWithTableView:_tableView target:self];
    self.tableView.tableFooterView = [UIView new];
    [_headerView addNFDateModel:[_dataSource getDateLimits] weeks:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:HEADER_NOTIF object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_NOTIF object:nil];
}

- (void)updateData {
    [_filterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    [_dataSource setSelectedDate:[_headerView.dateSourse.weekArray objectAtIndex:_headerView.selectedIndex]];
}



@end
