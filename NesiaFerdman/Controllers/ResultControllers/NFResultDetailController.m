//
//  NFResultDetailController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultDetailController.h"

@interface NFResultDetailController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NFResultDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;//_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = @"test";
    return cell;
}

#pragma mark - helpers


@end
