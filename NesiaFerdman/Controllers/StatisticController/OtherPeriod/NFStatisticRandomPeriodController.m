//
//  NFStatisticRandomPeriodController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticRandomPeriodController.h"
#import "NFStatisticRandomPeriodDataSource.h"
#import "NFPeriodFilterView.h"
#import "NFValuesFilterView.h"
#import "NotifyList.h"
#import "NFTaskManager.h"

@interface NFStatisticRandomPeriodController ()
@property (weak, nonatomic) IBOutlet NFPeriodFilterView *headerView;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *filterView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFStatisticRandomPeriodDataSource *dataSource;
@end

@implementation NFStatisticRandomPeriodController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NFStatisticRandomPeriodDataSource alloc] initWithTableView:_tableView target:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:HEADER_RANDOM_PERIOD object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_RANDOM_PERIOD object:nil];
}

- (void)updateData {
    [_filterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    [_dataSource setSelectedDate:_headerView.selectedDatePeriodArray];
}


@end