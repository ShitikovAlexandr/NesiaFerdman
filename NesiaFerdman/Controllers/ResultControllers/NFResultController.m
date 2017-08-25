//
//  NFResultController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultController.h"
#import "NotifyList.h"
#import "NFResultWeekDataSource.h"
#import "NFDataSourceManager.h"

@interface NFResultController ()
@property (weak, nonatomic) IBOutlet NFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFResultWeekDataSource *dataSource;
@end

@implementation NFResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Итоги";
    _dataSource = [[NFResultWeekDataSource alloc] initWithTableView:_tableView target:self];
    self.tableView.tableFooterView = [UIView new];
    [self.headerView addNFDateModel:[_dataSource getDateLimits] weeks:YES];
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
    [_dataSource setSelectedDate:[self.headerView.dateSourse.weekArray objectAtIndex:_headerView.selectedIndex]];
}

@end
