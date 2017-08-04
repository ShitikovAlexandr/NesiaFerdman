//
//  NFResultMonthController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/7/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultMonthController.h"
#import "NFHeaderMonthView.h"
#import "NFSettingManager.h"
#import "NotifyList.h"
#import "NFResultMonthDataSource.h"
#import "NFDataSourceManager.h"

@interface NFResultMonthController ()
@property (strong, nonatomic) IBOutlet NFHeaderMonthView *headerView;
@property (strong, nonatomic) NFResultMonthDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NFResultMonthController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_headerView setListOfDateWithStart:[NFSettingManager getMinDate] end:[NFSettingManager getMaxDate]];
    _dataSource = [[NFResultMonthDataSource alloc] initWithTableView:_tableView target:self];
    _tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:HEADER_MONTH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:END_UPDATE_DATA_SOURCE object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_MONTH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA_SOURCE object:nil];
}

- (void)updateData {
    [_dataSource setSelectedDate:_headerView.selectetDate];
}

@end
