//
//  NFStatisticMonthController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticMonthController.h"
#import "NFHeaderMonthView.h"
#import "NFValuesFilterView.h"
#import "NFStatisticMonthDataSource.h"
#import "NotifyList.h"
#import "NFTaskManager.h"
#import "NFSettingManager.h"


@interface NFStatisticMonthController ()
@property (weak, nonatomic) IBOutlet NFHeaderMonthView *headerView;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *filterView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFStatisticMonthDataSource *dataSource;
@end

@implementation NFStatisticMonthController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_headerView setListOfDateWithStart:[NFSettingManager getMinDate] end:[NFSettingManager getMaxDate]];
    _dataSource = [[NFStatisticMonthDataSource alloc] initWithTableView:_tableView target:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:HEADER_MONTH object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_MONTH object:nil];
}

- (void)updateData {
     [_filterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    [_dataSource setSelectedDate:_headerView.selectetDate];
}

@end
