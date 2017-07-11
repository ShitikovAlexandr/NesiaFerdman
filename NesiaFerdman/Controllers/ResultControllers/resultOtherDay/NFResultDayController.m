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
#import "NFResultDayDataSource.h"

@interface NFResultDayController ()
@property (weak, nonatomic) IBOutlet NFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFResultDayDataSource *dataSource;
@end

@implementation NFResultDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Итоги";
    _tableView.tableFooterView = [UIView new];
    _dataSource = [[NFResultDayDataSource alloc] initWithTableView:_tableView target:self];
    [self.headerView addNFDateModel:[_dataSource getDateLimits] weeks:NO];
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
    [_dataSource setSelectedDate:_headerView.selectetDate];
}

@end
