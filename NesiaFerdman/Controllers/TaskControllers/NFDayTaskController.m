//
//  NFDayTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/13/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDayTaskController.h"
#import "NFHeaderView.h"
#import "NotifyList.h"
#import "NFValuesFilterView.h"
#import "NFDataSourceManager.h"
#import "NFDayTaskDataSource.h"

@interface NFDayTaskController ()
@property (weak, nonatomic) IBOutlet NFHeaderView *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *ValuesFilterView;
@property (strong, nonatomic) NFDayTaskDataSource *dataSource;
@end

@implementation NFDayTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NFDayTaskDataSource alloc] initWithTableView:_tableView target:self];
    [_dataSource setCurrentCellVisible];

    [self.header addNFDateModel:[_dataSource getDateLimits] weeks:NO];
    self.header.selectetDate = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
    [_ValuesFilterView updateTitleFromArray:[[NFDataSourceManager sharedManager]getSelectedValueList]];
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
    [_dataSource setSelectedDate:_header.selectetDate];
}

@end
