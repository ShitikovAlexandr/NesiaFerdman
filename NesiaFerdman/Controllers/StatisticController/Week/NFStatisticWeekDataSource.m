//
//  NFStatisticWeekDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/17/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticWeekDataSource.h"
#import "NFSettingManager.h"
#import "NFStatisticMainCell.h"
#import "NFValuesFilterView.h"
#import "NFDataSourceManager.h"
#import "NFStatisticDetailController.h"

@interface NFStatisticWeekDataSource() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NFWeekDateModel *selectedWeek;
@property (strong, nonatomic) NFDateModel *dateLimits;
@property (strong, nonatomic) id target;
@property (strong, nonnull) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableArray *valuesArray;

@end

@implementation NFStatisticWeekDataSource

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[NFDataSourceManager sharedManager] getSelectedValueList].count) {
        return [[NFDataSourceManager sharedManager] getSelectedValueList].count;
    } else {
        return [[NFDataSourceManager sharedManager] getValueList].count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFStatisticMainCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"NFStatisticMainCell"];
    [cell addDatatoCellwithDictionary:_dataDictionary indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self navigateToDitailScreenWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190.0;
}

#pragma mark - Helpers

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target {
    if (self) {
        _target = target;
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _dataArray = [NSMutableArray new];
        _dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                     endDate:[NFSettingManager getMaxDate]];
        _dataArray = [NSMutableArray array];
        _dataDictionary = [NSMutableDictionary dictionary];
        [self.tableView registerNib:[UINib nibWithNibName:@"NFStatisticMainCell" bundle:nil] forCellReuseIdentifier:@"NFStatisticMainCell"];
    }
    return self;
}

- (void)setSelectedDate:(NFWeekDateModel*)week {
    _selectedWeek = week;
    [self addDataToDisplay];
}

- (NFDateModel*)getDateLimits {
    return _dateLimits;
}

- (void)addDataToDisplay {
    [self.dataDictionary removeAllObjects];
    NSMutableArray* eventsArray = [NSMutableArray array];
    for (NSDate *day in _selectedWeek.allDateOfWeek) {
       [eventsArray addObjectsFromArray: [[NFDataSourceManager sharedManager] getEventForDay:day]];
    }
    [self.dataDictionary setDictionary:[[NFDataSourceManager sharedManager] eventSortedByValue:eventsArray]];
    [self.tableView reloadData];
}

#pragma mark - navigation

- (void)navigateToDitailScreenWithIndexPath:(NSIndexPath*)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NFStatisticMainCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NFStatisticDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFStatisticDetailController"];
    viewController.selectedWeek = _selectedWeek;
    viewController.value = cell.value;
    viewController.type = WeekStatistic;
    [_target presentViewController:viewController animated:YES completion:nil];
}


@end
