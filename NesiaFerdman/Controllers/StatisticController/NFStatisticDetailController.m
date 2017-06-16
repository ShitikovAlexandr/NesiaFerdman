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

@interface NFStatisticDetailController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet STCollapseTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation NFStatisticDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self.tableView reloadData];
    [self.tableView openSection:0 animated:NO];
//    [self.tableView registerNib:[UINib nibWithNibName:@"NFTaskSimpleCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTaskSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NFTaskSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = @"test";
    return  cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [NFHeaderForTaskSection headerSize];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NFHeaderForTaskSection *headerView = [[NFHeaderForTaskSection alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [NFHeaderForTaskSection headerSize])];
    //NSArray *eventDayArray = [_dataArray objectAtIndex:section];
    //NFEvent *event = [eventDayArray firstObject];
    //[headerView setCurrentDate:[self stringDate:event.startDate withFormat:@"yyyy-MM-dd"]];
    //[headerView setTaskCount:eventDayArray];
    return headerView;
}

#pragma mark - Helpers

- (void)exitAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
