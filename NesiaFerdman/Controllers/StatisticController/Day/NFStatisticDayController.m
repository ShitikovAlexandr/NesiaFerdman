//
//  NFStatisticDayController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticDayController.h"
#import "NFHeaderView.h"
#import "NFValuesFilterView.h"
#import "NFStatisticDayDataSource.h"
#import "NotifyList.h"
#import "NFDataSourceManager.h"


@interface NFStatisticDayController ()
@property (weak, nonatomic) IBOutlet NFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *filterView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFStatisticDayDataSource *dataSource;
@end

@implementation NFStatisticDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NFStatisticDayDataSource alloc] initWithTableView:_tableView target:self];
    self.tableView.tableFooterView = [UIView new];
    [_headerView addNFDateModel:[_dataSource getDateLimits] weeks:NO];
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
    [_filterView updateTitleFromArray:[[NFDataSourceManager sharedManager] getSelectedValueList]];
    [_dataSource setSelectedDate:_headerView.selectetDate];
}


@end
