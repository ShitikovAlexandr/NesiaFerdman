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
@property (strong, nonatomic) NSMutableArray *dateForTitleSection;
@end

@implementation NFStatisticDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateForTitleSection = [NSMutableArray array];
    self.doneTaskTitle.text = @"выполненных\nзадач";
    self.allTaskTitle.text = @"поставленных\nзадач";
    self.dataArray = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskSimpleCell* eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (eventCell.event) {
        [self navigateToEditTaskScreenWithEvent:eventCell.event];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return [NFHeaderForTaskSection headerSize];
    } else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
    if (_dataArray.count > 0) {
        NSArray *eventDayArray = [_dataArray objectAtIndex:section];
        [headerView setTaskCount:eventDayArray];
    }
    if ([[_dateForTitleSection objectAtIndex:section] isKindOfClass:[NSDate class]]) {
        [headerView setCurrentDate:[_dateForTitleSection objectAtIndex:section]];
    }
    return headerView;
}

#pragma mark - Helpers

- (void)loadEvents {
    [self updateDataStatistic];
}

- (void)updateDataStatistic {
    [_dataArray removeAllObjects];
    if (_value) {
        self.screenTitle.text = self.value.valueTitle;
        [self.valueImage setImage:[UIImage imageNamed:_value.valueImage]];
    } else {
        self.screenTitle.text = @"Другое";
        [self.valueImage setImage:[UIImage imageNamed:@"defaultValue.png"]];
    }
    
    switch (_type) {
        case DayStatistic: {
            [_dateForTitleSection addObject:_selectedDate];
            if (_value) {
                [_dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getTaskForDay:_selectedDate withValue:_value]];
            } else {
                [_dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getTaskForDayWithoutValues:_selectedDate]];
            }
            break;
        }
        case WeekStatistic: {
            if (_value) {
                for (NSDate* day in _selectedWeek.allDateOfWeek) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    [tempArray addObjectsFromArray:[[NFTaskManager sharedManager] getTaskForDay:day withValue:_value]];
                    if (tempArray.count > 0) {
                        [_dateForTitleSection addObject:day];
                        [_dataArray addObjectsFromArray:tempArray];
                    }
                }
            } else {
                for (NSDate* day in _selectedWeek.allDateOfWeek) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    [tempArray addObjectsFromArray:[[NFTaskManager sharedManager] getTaskForDayWithoutValues:day]];
                    if (tempArray.count > 0) {
                        [_dateForTitleSection addObject:day];
                        [_dataArray addObjectsFromArray:tempArray];
                    }
                }
            }
            break;
        }
        case MonthStatistic: {
            if (_value) {
                NSDictionary *tempDictionary = [[NSDictionary alloc]  initWithDictionary:[[NFTaskManager sharedManager] getTaskForMonthDictionary:_selectedDate withValue:_value]];
                NSArray *filtered = [[tempDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                for (NSString *key in filtered) {
                    [_dataArray addObject:[tempDictionary objectForKey:key]];
                    [_dateForTitleSection addObject:[self keyStringToDate:key]];
                }
            } else {
                NSDictionary *tempDictionary = [[NSDictionary alloc]  initWithDictionary:[[NFTaskManager sharedManager] getTaskForMonthWithoutValues:_selectedDate]];
                NSArray *filtered = [[tempDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                for (NSString *key in filtered) {
                    [_dataArray addObject:[tempDictionary objectForKey:key]];
                    [_dateForTitleSection addObject:[self keyStringToDate:key]];
                }
            }
            break;
        }
        case OtherStatistic: {
            if (_value) {
                for (NSDate* day in _selectedDateArray) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    [tempArray addObjectsFromArray:[[NFTaskManager sharedManager] getTaskForDay:day withValue:_value]];
                    if (tempArray.count > 0) {
                        [_dateForTitleSection addObject:day];
                        [_dataArray addObjectsFromArray:tempArray];
                    }
                }
            } else {
                for (NSDate* day in _selectedDateArray) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    [tempArray addObjectsFromArray:[[NFTaskManager sharedManager] getTaskForDayWithoutValues:day]];
                    if (tempArray.count > 0) {
                        [_dateForTitleSection addObject:day];
                        [_dataArray addObjectsFromArray:tempArray];
                    }
                }
            }

            break;
        }
        default:
            break;
    }
    self.monthLabel.text = [[self dateToString:[_dateForTitleSection firstObject]] uppercaseString];
    [self.tableView reloadData];
    [self setCountTasksWithArray:_dataArray];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.progressLayer.strokeEnd =  [self setProgressValueWithData:_dataArray];
    });
    
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
    
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:[stringInput substringToIndex:10]];
    return dateFromString;
}

- (NSString *)dateToString:(NSDate *)date {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LLLL"];
    return [dateFormatter stringFromDate:date];
}

- (CGFloat)setProgressValueWithData:(NSMutableArray*)dataArray; {
    int doneCount = 0;
    int taskCount = 0;
    if (_dataArray.count > 0) {
        for (NSArray *dayArray in dataArray) {
            for (NFEvent *event in dayArray) {
                taskCount++;
                if (event.isDone) {
                    doneCount++;
                }
            }
        }
        return (1.0/(CGFloat)taskCount) * doneCount;
    } else {
        return 0;
    }
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

- (NSDate*)keyStringToDate:(NSString*)key {
    NFDateFormatter *formatter = [[NFDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:key];
}

@end
