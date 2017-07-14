//
//  NFStatisticDayDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticDayDataSource.h"
#import "NFSettingManager.h"
#import "NFStatisticMainCell.h"
#import "NFValuesFilterView.h"

@interface NFStatisticDayDataSource() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NFDateModel *dateLimits;
@property (strong, nonatomic) id target;

@property (strong, nonnull) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableArray *valuesArray;




@end

@implementation NFStatisticDayDataSource

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFStatisticMainCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"NFStatisticMainCell"];
    [cell addDatatoCellwithDictionary:_dataDictionary indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190.0;
}

#pragma mark - Helpers

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target {
    if (self) {
        [self.tableView registerNib:[UINib nibWithNibName:@"NFStatisticMainCell" bundle:nil] forCellReuseIdentifier:@"NFStatisticMainCell"];
        _target = target;
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _dataArray = [NSMutableArray new];
        _dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                     endDate:[NFSettingManager getMaxDate]];
    }
    return self;
}

- (void)setSelectedDate:(NSDate*)date {
    _selectedDate = date;
}

- (NFDateModel*)getDateLimits {
    return _dateLimits;
}

- (void)addDataToDisplay {

}


@end
