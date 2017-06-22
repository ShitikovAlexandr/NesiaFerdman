//
//  NFResultDetailController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultDetailController.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFEditResultController.h"
#import "NFResultCell.h"
#import "NFHeaderForTaskSection.h"
#import "NFWeekDateModel.h"
#import "NFTaskManager.h"

@interface NFResultDetailController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NFResultDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.title = self.selectedCategory.resultCategoryTitle;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewItem)];
    self.navigationItem.rightBarButtonItem = item;

    self.tableView.tableFooterView = [UIView new];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self navigateToEditScreenWithItem:eventCell.event];
    
}

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
        [headerView.iconImage setImage:[UIImage imageNamed:@"List_Document@2x.png"]];
        NSArray *eventDayArray = [_dataArray objectAtIndex:section];
        NFResult *event = [eventDayArray firstObject];
        [headerView setCurrentDate:[self stringDate:event.startDate withFormat:@"yyyy-MM-dd"]];
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] init];
        return headerView;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count > 0 ? _dataArray.count : 1;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = _dataArray.count > 0 ? [self.dataArray objectAtIndex:section] : [NSArray array];
    return sectionData.count > 0 ? sectionData.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NFResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (self.dataArray.count > 0) {
        NSArray *eventDayArray = [_dataArray objectAtIndex:indexPath.section];
        NFResult *event = [eventDayArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        [cell addData:nil];
    }
    return cell;
}

#pragma mark - helpers

- (void)addDataToDisplay {
    [self.dataArray removeAllObjects];
    NFWeekDateModel *week = _week;
    for (NSDate *dayDate in week.allDateOfWeek) {
        NSMutableArray *dayArray = [NSMutableArray array];
        [dayArray addObjectsFromArray:[[NFTaskManager sharedManager] getResultWithFilter:_selectedCategory forDay:dayDate]];
        if (dayArray.count > 0) {
            [self.dataArray addObject:dayArray];
        }
    }
    [self.tableView reloadData];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationTop];
}

- (void)navigateToEditScreenWithItem:(NFResult*)result {
    NFEditResultController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFEditResultController"];
    viewController.category = self.selectedCategory;
    viewController.resultItem = result;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSDate *)stringDate:(NSString *)stringInput
            withFormat:(NSString *)inputFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    NSLog(@"new date %@", dateFromString);
    return dateFromString;
}

- (void)createNewItem {
 NFEditResultController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFEditResultController"];
    viewController.category = self.selectedCategory;
    viewController.resultItem = nil;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
