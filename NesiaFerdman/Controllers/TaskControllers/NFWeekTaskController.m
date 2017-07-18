//
//  NFWeekTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFWeekTaskController.h"
#import "NFHeaderView.h"
#import "NFWeekTaskCell.h"
#import "NFWeekDayView.h"
#import "NotifyList.h"
#import "NFWeekDateModel.h"
#import "NFWeekDaysHeader.h"
#import "NFHeaderDayOfWeek.h"
#import "NFTaskSimpleCell.h"
#import "NFHeaderForTaskSection.h"
#import "NFValuesFilterView.h"
#import "NFSettingManager.h"

@interface NFWeekTaskController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NFHeaderView *header;
//@property (weak, nonatomic) IBOutlet NFWeekDaysHeader *headerWeek;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *ValuesFilterView;
@property (strong, nonatomic) NSMutableArray *keyArray;

@end

@implementation NFWeekTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.keyArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFTaskSimpleCell" bundle:nil] forCellReuseIdentifier:@"NFTaskSimpleCell"];
    self.tableView.tableFooterView = [UIView new];
    NFDateModel *dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                             endDate:[NFSettingManager getMaxDate]];
    [self.header addNFDateModel:dateLimits weeks:YES];
    [_ValuesFilterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_ValuesFilterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    [self addDataToDisplay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataToDisplay) name:HEADER_NOTIF object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_NOTIF object:nil];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count > 0 ? _dataArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = _dataArray.count > 0 ? [self.dataArray objectAtIndex:section] : [NSArray array];
    return sectionData.count > 0 ? sectionData.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSString * const identifier = @"NFTaskSimpleCell";
    NFTaskSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NFTaskSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (self.dataArray.count > 0) {
        NSArray *eventDayArray = [_dataArray objectAtIndex:indexPath.section];
        NFEvent *event = [eventDayArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        [cell addData:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        return [NFHeaderForTaskSection headerSize];
    } else {
        return 0.0001;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.view removeGestureRecognizer:[[UIGestureRecognizer alloc] init]];
    if (self.dataArray.count > 0) {
        NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
        [headerView.iconImage setImage:[UIImage imageNamed:@"task_section_icon.png"]];
        NSArray *eventDayArray = [_dataArray objectAtIndex:section];
        NFEvent *event = [eventDayArray firstObject];
        [headerView setCurrentDate:[self stringDate:event.startDate withFormat:@"yyyy-MM-dd"]];
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] init];
        return headerView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskSimpleCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditTaskScreenWithEvent:eventCell.event];
}


#pragma mark - Helpers

- (void)addDataToDisplay {
    [self.dataArray removeAllObjects];
    NFWeekDateModel *week = [self.header.dateSourse.weekArray objectAtIndex:_header.selectedIndex];
    for (NSDate *dayDate in week.allDateOfWeek) {
        NSMutableArray *dayArray = [NSMutableArray array];
        dayArray = [[NFTaskManager sharedManager] getTasksForDay:dayDate];
        if (dayArray.count > 0) {
            [self.dataArray addObject:dayArray];
            [self.keyArray addObject:dayDate];
        }
    }
    [self.tableView reloadData];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationTop];
}

- (NSDate *)stringDate:(NSString *)stringInput
            withFormat:(NSString *)inputFormat {
    
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    return dateFromString;
}

- (void)filterAction {
    [super filterAction];
}

- (void)didDismissViewController:(UIViewController*)vc
{
    // this method gets called in MainVC when your SecondVC is dismissed
    NSLog(@"Dismissed SecondViewController");
}

@end
