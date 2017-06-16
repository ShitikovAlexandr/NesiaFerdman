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
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
    NFDateModel *dateLimits = [[NFDateModel alloc] initWithStartDate:startDate endDate:endDate];
    [self.header addNFDateModel:dateLimits weeks:NO];
    self.header.selectetDate = [NSDate date];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelectionDuringEditing = YES;
    [self addDataToDisplay];
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
        NFEvent *event = [self.eventsArray objectAtIndex:indexPath.row];
        [cell addData:event];
    } else {
        cell.textLabel.text = @"Нет задач";
        [tableView setEditing:NO animated:YES];

    }
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        [tableView setEditing:NO animated:YES];
    } else {
        NSLog(@"go to detail screen");
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
        [self.eventsArray removeObjectAtIndex:indexPath.row];
        if (_eventsArray.count>0) {
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];

        } else {
            [_tableView reloadData];
        }
    }
    
}


#pragma mark - Helpers -

- (void)addDataToDisplay {
    
    // NSLog(@"change Day -> %@", self.header.selectetDate);
    [self.eventsArray removeAllObjects];
    [self.eventsArray addObjectsFromArray:[[NFTaskManager sharedManager] getImportantForDay:self.header.selectetDate]];
    [_tableView setEditing:NO animated:YES];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    NSLog(@"day header %@", self.header.selectetDate);
    NSLog(@"eventsArray for day %@", _eventsArray);
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

- (void)cellSendLongTouch {
    if (_eventsArray.count > 0 && !_tableView.editing ) {
        [_tableView setEditing:YES animated:YES];
        NSLog(@"edit");
    }
}



@end
