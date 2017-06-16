//
//  NFWeekConclusionsController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/15/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFWeekConclusionsController.h"
#import "NFHeaderView.h"
#import "NFWeekDateModel.h"
#import "NotifyList.h"
#import "NFTaskSimpleCell.h"
#import "NFHeaderForTaskSection.h"

@interface NFWeekConclusionsController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NFHeaderView *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation NFWeekConclusionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFTaskSimpleCell" bundle:nil] forCellReuseIdentifier:@"NFTaskSimpleCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelectionDuringEditing = YES;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
    NFDateModel *dateLimits = [[NFDateModel alloc] initWithStartDate:startDate endDate:endDate];
    [self.header addNFDateModel:dateLimits weeks:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataToDisplay) name:HEADER_NOTIF object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSendLongTouch) name:LONG_CELL_PRESS object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_NOTIF object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LONG_CELL_PRESS object:nil];
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
        return [NFHeaderForTaskSection headerSize];
    } else {
        return 1.f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.view removeGestureRecognizer:[[UIGestureRecognizer alloc] init]];
    if (self.dataArray.count > 0) {
        NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,[NFHeaderForTaskSection headerSize])];
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
    if (tableView.editing) {
        [tableView setEditing:NO animated:YES];
    } else {
        NSLog(@"go to detail screen");
        [self cellSendLongTouch];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
        [[self.dataArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        if(![[self.dataArray objectAtIndex:indexPath.section] count]) {
            [self.dataArray removeObjectAtIndex:indexPath.section];
            [tableView reloadData];
        } else {
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            [self.tableView setNeedsDisplay];
        }
    }
}

#pragma mark - Helpers

- (void)addDataToDisplay {
    [self.dataArray removeAllObjects];
    NFWeekDateModel *week = [self.header.dateSourse.weekArray objectAtIndex:_header.selectedIndex];
    for (NSDate *dayDate in week.allDateOfWeek) {
        NSMutableArray *dayArray = [NSMutableArray array];
        dayArray = [[NFTaskManager sharedManager] getConclusionsForDay:dayDate];
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

- (void)cellSendLongTouch {
    if (_dataArray.count > 0 && !_tableView.editing ) {
        [_tableView setEditing:YES animated:YES];
        NSLog(@"edit");
    }
}





@end
