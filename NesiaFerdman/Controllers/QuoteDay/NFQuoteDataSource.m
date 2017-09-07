//
//  NFQuoteDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 9/7/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFQuoteDataSource.h"

@interface NFQuoteDataSource() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NFNQuote *quote;
@end

@implementation NFQuoteDataSource

- (instancetype)initWithTableView:(UITableView*)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60.0;
        _quote = [[NFNQuote alloc] init];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"QCell"];
    }
    if (_quote) {
        if (indexPath.row == 0) {
            cell.textLabel.text = _quote.title;
            cell.detailTextLabel.text = @"";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = _quote.author;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)setQuote:(NFNQuote*)quote {
    _quote = quote;
    [_tableView reloadData];
}




@end
