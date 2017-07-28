//
//  NFDayTaskDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDayTaskDataSource.h"
#import "NFDataSourceManager.h"
#import "NFSettingManager.h"
#import "NFDayTableViewCell.h"
#import "NFEditTaskController.h"

@interface NFDayTaskDataSource ()  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) id target;
@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) NFDateModel *dateLimits;
@property (strong, nonatomic) NSDate *selectedDate;
@end

@implementation NFDayTaskDataSource

- (instancetype)initWithTableView:(UITableView*)tableview target:(id)target {
    self = [super init];
    if (self) {
        _tableView = tableview;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _target = target;
        _eventsArray = [NSMutableArray array];
        _dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                     endDate:[NFSettingManager getMaxDate]];
        [self.tableView registerNib:[UINib nibWithNibName:@"NFDayTableViewCell" bundle:nil] forCellReuseIdentifier:@"NFDayTableViewCell"];
    }
    return self;
}

- (NFDateModel*)getDateLimits {
    return _dateLimits;
}

- (void)setSelectedDate:(NSDate*)date {
    _selectedDate = date;
    [self getData];
}

- (void)getData {
    [self.eventsArray removeAllObjects];
    [self.eventsArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getEventForDay:_selectedDate]];
    [self.tableView reloadData];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationTop];
}

- (NSArray*)setValueFilterData {
    return [[NFDataSourceManager sharedManager]getSelectedValueList];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 24;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[NFDataSourceManager sharedManager] getEventForHour:section WithArray:_eventsArray] count] > 0) {
        return [[[NFDataSourceManager sharedManager] getEventForHour:section WithArray:_eventsArray] count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFDayTableViewCell"];
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFDayTableViewCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditTaskScreenWithEvent:eventCell.event];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(NFDayTableViewCell*)cell addData:_eventsArray withIndexPath:indexPath date:_selectedDate];
}

#pragma mark - Helpers -

- (void)setCurrentCellVisible {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H"];
    NSInteger row =  [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:row];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (NSString *)dateFormater:(NSString *)dateString {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:8]];
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString* newDate = [dateFormatter1 stringFromDate:dateFromString];
    return newDate;
}

#pragma mark - navigation

- (void)navigateToEditTaskScreenWithEvent:(NFNEvent*)event {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NFEditTaskController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFEditTaskController"];
    viewController.event = event;
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFEditTaskNavController"];
    [navController setViewControllers:@[viewController]];
    [_target presentViewController:navController animated:YES completion:nil];
}

@end
