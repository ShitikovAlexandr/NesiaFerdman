//
//  NFStatisticDetailController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/15/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticDetailController.h"
#import "STCollapseTableView.h"
#import "NFHeaderForTaskSection.h"
#import "NFTaskSimpleCell.h"
#import "NFStyleKit.h"
#import "NFHeaderForTaskSection.h"
#import "NFTaskManager.h"
#import "NFRoundProgressView.h"
#import "NFAnimatedLabel.h"

@interface NFStatisticDetailController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *valueImage;

@property (weak, nonatomic) IBOutlet NFRoundProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (weak, nonatomic) IBOutlet UILabel *allTaskTitle;
@property (weak, nonatomic) IBOutlet NFAnimatedLabel *allTaskCount;
@property (weak, nonatomic) IBOutlet NFAnimatedLabel *doneTaskCount;
@property (weak, nonatomic) IBOutlet UILabel *doneTaskTitle;

@end

@implementation NFStatisticDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.monthLabel.text = [[self dateToString:_selectedDate] uppercaseString];
    self.doneTaskTitle.text = @"выполненных\nзадач";
    self.allTaskTitle.text = @"поставленных\nзадач";
    self.dataArray = [NSMutableArray array];
    [self.valueImage setImage:[UIImage imageNamed:_value.valueImage]];
//    [self.tableView openSection:0 animated:NO];
    [self.navButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadEvents];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  _dataArray.count > 0 ? _dataArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = _dataArray.count > 0 ? [self.dataArray objectAtIndex:section] : [NSArray array];
    return sectionData.count > 0 ? sectionData.count : 1;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return [NFHeaderForTaskSection headerSize];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
    NSArray *eventDayArray = [_dataArray objectAtIndex:section];
    NFEvent *event = [eventDayArray firstObject];
    [headerView setCurrentDate:[self stringDate:event.startDate withFormat:@"yyyy-MM-dd"]];
    [headerView setTaskCount:eventDayArray];
    return headerView;
}

#pragma mark - Helpers

- (void)loadEvents {
    [_dataArray removeAllObjects];
    
    if (_value) {
        [_dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getTaskForMonth:_selectedDate withValue:_value]];
        self.screenTitle.text = self.value.valueTitle;
        [self.tableView reloadData];
        [self setCountTasksWithArray:_dataArray];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progressLayer.strokeEnd =  [self setProgressValueWithData:_dataArray];
        });
    }
   
}

- (void)exitAction {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSDate *)stringDate:(NSString *)stringInput
            withFormat:(NSString *)inputFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    return dateFromString;
}

- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LLLL"];
    return [dateFormatter stringFromDate:date];
}


- (CGFloat)setProgressValueWithData:(NSMutableArray*)dataArray; {
    int doneCount = 0;
    int taskCount = 0;
    for (NSArray *dayArray in dataArray) {
        for (NFEvent *event in dayArray) {
            taskCount++;
            if (event.isDone) {
                doneCount++;
            }
        }
    }
    return (1.0/(CGFloat)taskCount) * doneCount;
}

- (void)setCountTasksWithArray:(NSMutableArray*)dataArray {
    int doneCount = 0;
    int taskCount = 0;
    for (NSArray *dayArray in dataArray) {
        for (NFEvent *event in dayArray) {
            taskCount++;
            if (event.isDone) {
                doneCount++;
            }
        }
    }
    self.doneTaskCount.text = [NSString stringWithFormat:@"%i", doneCount];
    self.allTaskCount.text = [NSString stringWithFormat:@"%i", taskCount];
}

@end
