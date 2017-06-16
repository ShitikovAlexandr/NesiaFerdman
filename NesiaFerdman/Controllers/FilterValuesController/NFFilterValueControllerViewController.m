//
//  NFFilterValueControllerViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFFilterValueControllerViewController.h"
#import "NFTaskManager.h"
#import "NFValue.h"
#import "NFValueFilterCell.h"

@interface NFFilterValueControllerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NSMutableArray *selectedValue;
@end

@implementation NFFilterValueControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ценности";
    self.tableView.tableFooterView = [UIView new];
    _valuesArray = [NSMutableArray array];
    _selectedValue = [NSMutableArray array];
    [_selectedValue addObjectsFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    [self getAllValues];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFValueFilterCell" bundle:nil] forCellReuseIdentifier:@"NFValueFilterCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _valuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFValueFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFValueFilterCell"];
    NFValue *val = [_valuesArray objectAtIndex:indexPath.row];
    [cell addData:val];
    cell.valueSwitcer.tag = indexPath.row;
    [cell.valueSwitcer addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - Helpers

- (IBAction)saveOrCancelAction:(UIBarButtonItem *)sender {
    
    NSLog(@"selected value %@", [NFTaskManager sharedManager].selectedValuesArray);
    
    if (sender.tag == 2) //save
    {
        [[NFTaskManager sharedManager].selectedValuesArray removeAllObjects];
        [[NFTaskManager sharedManager].selectedValuesArray addObjectsFromArray:_selectedValue];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getAllValues {
    [_valuesArray addObjectsFromArray:[[NFTaskManager sharedManager] getAllValues]];
    [_tableView reloadData];
}

- (void) switchToggled:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"its on! with tag %ld", (long)sender.tag);
        NFValue *value = [_valuesArray objectAtIndex:sender.tag];
        [_selectedValue addObject:value];
    } else {
        NSLog(@"its off! with tag %ld", (long)sender.tag);
        NFValue *value = [_valuesArray objectAtIndex:sender.tag];
        [_selectedValue removeObject:value];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
