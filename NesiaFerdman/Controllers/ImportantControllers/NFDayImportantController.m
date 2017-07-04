//
//  NFDayImportantController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDayImportantController.h"
#import "NFHeaderView.h"
#import "NFTaskSimpleCell.h"
#import "NotifyList.h"
#import "NFSyncManager.h"
#import "NFTAddImportantTaskTableViewController.h"
#import "NFSettingManager.h"

@interface NFDayImportantController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NFHeaderView *header;
@property (strong, nonatomic) NSMutableArray *eventsArray;
@end

@implementation NFDayImportantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventsArray =  [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFTaskSimpleCell" bundle:nil] forCellReuseIdentifier:@"NFTaskSimpleCell"];
//    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
//    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
    NFDateModel *dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                             endDate:[NFSettingManager getMaxDate]];
    [self.header addNFDateModel:dateLimits weeks:NO];
    self.header.selectetDate = [NSDate date];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataToDisplay) name:HEADER_NOTIF object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEADER_NOTIF object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LONG_CELL_PRESS object:nil];

}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_eventsArray.count > 0) {
        return _eventsArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NFTaskSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (self.eventsArray.count > 0) {
        NFEvent *event = [_eventsArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        [cell addData:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskSimpleCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditTaskScreenWithEvent:eventCell.event];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

#pragma mark - Helpers -

- (void)addDataToDisplay {
    [self.eventsArray removeAllObjects];
    [self.eventsArray addObjectsFromArray:[[NFTaskManager sharedManager] getImportantForDay:self.header.selectetDate]];
    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
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

- (void)navigateToEditTaskScreenWithEvent:(NFEvent*)event {
    NFTAddImportantTaskTableViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NFTAddImportantTaskTableViewController"];
    addVC.event = event;
    addVC.eventType = Important;
    UINavigationController *navVCB = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavViewController"];
    navVCB.navigationBar.barStyle = UIBarStyleBlack;
    [navVCB setViewControllers:@[addVC] animated:YES];
    [self presentViewController:navVCB animated:YES completion:nil];
}

- (void)cellSendLongTouch {
    if (_eventsArray.count > 0 && !_tableView.editing ) {
        [_tableView setEditing:YES animated:YES];
    }
}





@end
