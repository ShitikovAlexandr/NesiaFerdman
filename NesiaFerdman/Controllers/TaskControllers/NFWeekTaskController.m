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

@interface NFWeekTaskController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NFHeaderView *header;
//@property (weak, nonatomic) IBOutlet NFWeekDaysHeader *headerWeek;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet NFValuesFilterView *ValuesFilterView;

@end

@implementation NFWeekTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFTaskSimpleCell" bundle:nil] forCellReuseIdentifier:@"NFTaskSimpleCell"];
    self.tableView.tableFooterView = [UIView new];
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
    NFDateModel *dateLimits = [[NFDateModel alloc] initWithStartDate:startDate endDate:endDate];
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
        cell.textLabel.text = @"Нет задач";
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        return 34.f;//[NFHeaderForTaskSection headerSize];
    } else {
        return 0.0001;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.view removeGestureRecognizer:[[UIGestureRecognizer alloc] init]];
    if (self.dataArray.count > 0) {
        NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
        [headerView.iconImage setImage:[UIImage imageNamed:@"List_Document@2x.png"]];
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
        }
    }
    [_tableView setEditing:NO animated:YES];
    [self.tableView reloadData];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationTop];
}

- (NSDate *)stringDate:(NSString *)stringInput
            withFormat:(NSString *)inputFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    NSLog(@"new date %@", dateFromString);
    return dateFromString;
}

//- (void)cellSendLongTouch {
//    if (_dataArray.count > 0 && !_tableView.editing ) {
//        [_tableView setEditing:YES animated:YES];
//        NSLog(@"edit");
//    }
//}


//#pragma mark - UITableViewDataSource -
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 24;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NFWeekTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFWeekTaskCell"];
//    cell.timeLabel.text = [NSString stringWithFormat:@"%02ld", (long)indexPath.row];
//    [cell addDataWithEventsArray:_dataArray indexPath:indexPath];
//    
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate -
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 80;
//}
//
//- (void)addDataToDisplay {
//    [self.dataArray removeAllObjects];
//        NFWeekDateModel *week = [self.header.dateSourse.weekArray objectAtIndex:_header.selectedIndex];
//        for (NSDate *dayDate in week.allDateOfWeek) {
//            NSMutableArray *dayArray = [NSMutableArray array];
//            dayArray = [[NFTaskManager sharedManager] getTasksForDay:dayDate];
//            [self.dataArray addObject:dayArray];
//        }
////    [self updateWeekHeader];
//    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
//}

//- (void)setCurrentCellVisible {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"H"];
//    NSInteger row =  [[dateFormatter stringFromDate:[NSDate date]] integerValue];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath
//                          atScrollPosition:UITableViewScrollPositionTop
//                                  animated:YES];
//}

//- (void)updateWeekHeader {
//    NFWeekDateModel *week = [self.header.dateSourse.weekArray objectAtIndex:_header.selectedIndex];
//    for (int i = 0; i < self.headerWeek.daysHeaderViews.count; i++) {
//        [((NFHeaderDayOfWeek*)[self.headerWeek.daysHeaderViews objectAtIndex:i]) setDate:[week.allDateOfWeek objectAtIndex:i]];
//    }
//}

- (void)filterAction {
    [super filterAction];
}

- (void)didDismissViewController:(UIViewController*)vc
{
    // this method gets called in MainVC when your SecondVC is dismissed
    NSLog(@"Dismissed SecondViewController");
}

@end
