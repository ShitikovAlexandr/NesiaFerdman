//
//  NFDayTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/13/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDayTaskController.h"
#import "NFHeaderCell.h"
#import "NFHeaderView.h"
#import "NFDayTableViewCell.h"
#import "NFSegmentedControl.h"
#import "NFDateModel.h"
#import "NFWeekDateModel.h"
#import "NFGoogleManager.h"
#import "NotifyList.h"
#import "NFSyncManager.h"
#import "NFValuesFilterView.h"
#import "NFStyleKit.h"
#import "NFSettingManager.h"

@interface NFDayTaskController () <UITableViewDelegate, UITableViewDataSource, NFHeaderViewProtocol>

@property (weak, nonatomic) IBOutlet NFHeaderView *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *ValuesFilterView;

@end

@implementation NFDayTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventsArray =  [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFDayTableViewCell" bundle:nil] forCellReuseIdentifier:@"NFDayTableViewCell"];
//    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
//    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
    NFDateModel *dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                             endDate:[NFSettingManager getMaxDate]];
    [self.header addNFDateModel:dateLimits weeks:NO];
    self.header.selectetDate = [NSDate date];
    [self setCurrentCellVisible];
    [self addDataToDisplay];
    [_ValuesFilterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
    [_ValuesFilterView updateTitleFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataToDisplay) name:HEADER_NOTIF object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_NOTIF object:nil];
}


#pragma mark - UITableViewDataSource -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 24;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[NFTaskManager sharedManager] getTaskForHour:section WithArray:_eventsArray] count] > 0) {
        return [[[NFTaskManager sharedManager] getTaskForHour:section WithArray:_eventsArray] count];
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFDayTableViewCell"];
    //    cell.timeLabel.text = [NSString stringWithFormat:@"%02ld", (long)indexPath.row];
    //[cell addData:_eventsArray withIndexPath:indexPath date:_header.selectetDate];
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFDayTableViewCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditTaskScreenWithEvent:eventCell.event];
 }



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(NFDayTableViewCell*)cell addData:_eventsArray withIndexPath:indexPath date:_header.selectetDate];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 2.0;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    CGRect sepFrame = CGRectMake(0, 0, self.tableView.frame.size.width , 1.0);
//    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
//    return seperatorView;
//}
//


#pragma mark - Helpers -

- (void)setCurrentCellVisible {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H"];
    NSInteger row =  [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:row];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)addDataToDisplay {
    
    [self.eventsArray removeAllObjects];
    [self.eventsArray addObjectsFromArray:[[NFTaskManager sharedManager] getTasksForDay:self.header.selectetDate]];
    [self.tableView reloadData];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationTop];
}

- (NSString *)dateFormater:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:8]];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString* newDate = [dateFormatter1 stringFromDate:dateFromString];
    return newDate;
}

- (void) reselectDate {
    
}

- (void)addButtonAction {
    NSLog(@":)");
}

- (void)updateFilterTitle {
    
}


@end
