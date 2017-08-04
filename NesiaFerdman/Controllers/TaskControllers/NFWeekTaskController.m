//
//  NFWeekTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFWeekTaskController.h"
#import "NFHeaderView.h"
#import "NotifyList.h"
#import "NFValuesFilterView.h"
#import "NFDataSourceManager.h"
#import "NFWeekTaskDataSource.h"

@interface NFWeekTaskController ()
@property (weak, nonatomic) IBOutlet NFHeaderView *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *ValuesFilterView;
@property (strong, nonatomic) NFWeekTaskDataSource *dataSource;

@end

@implementation NFWeekTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NFWeekTaskDataSource alloc] initWithTableView:_tableView target:self];
    self.tableView.tableFooterView = [UIView new];
    [self.header addNFDateModel:[_dataSource getDateLimits] weeks:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:HEADER_NOTIF object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:END_UPDATE_DATA_SOURCE object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_NOTIF object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA_SOURCE object:nil];
}

- (void)updateData {
    [_ValuesFilterView updateTitleFromArray:[_dataSource setValueFilterData]];
    NFWeekDateModel *week = [self.header.dateSourse.weekArray objectAtIndex:_header.selectedIndex];
    [_dataSource setSelectedDate:week];
}

@end
