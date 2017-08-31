//
//  NFResultMenuCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultMenuCell.h"
#import "NFDataSourceManager.h"

@implementation NFResultMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init methods

- (instancetype)initWithDefaultStyle {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NFResultMenuCell"];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        self.textLabel.numberOfLines = 0;

    }
    return self;
}

- (void)animateLabel:(UILabel*)label {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.type = kCATransitionReveal;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [label.layer addAnimation:animation forKey:@"changeTextTransition"];
}

#pragma mark - parse data to cell methods

- (void)addDataToCell:(NFNRsultCategory*)category date:(NFWeekDateModel*)currentDate {
    [self animateLabel:self.detailTextLabel];
    self.textLabel.text = category.title;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%li", (long)[self getCategoryCountForWeek:currentDate category:category]];

}

- (void)addDataToDayCell:(NFNRsultCategory *)category date:(NSDate *)currentDate {
    [self animateLabel:self.detailTextLabel];
    self.textLabel.text = category.title;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%li", (long)[self getCategoryCountForDay:currentDate category:category]];
}

- (void)addDataToMonthCell:(NFNRsultCategory*)category date:(NSDate*)currentDate {
    [self animateLabel:self.detailTextLabel];
    self.textLabel.text = category.title;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%li", (long)[self getCategoryCountForMonth:currentDate category:category]];
}

#pragma mark - Result count methods

- (NSInteger)getCategoryCountForDay:(NSDate*)day category:(NFNRsultCategory*)category {
    NSMutableArray *dayArray = [NSMutableArray array];
    [dayArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getResultWithFilter:category forDay:day]];
    return dayArray.count;
}

- (NSInteger)getCategoryCountForWeek:(NFWeekDateModel*)week category:(NFNRsultCategory*)category {
    NSInteger count = 0;
    for (NSDate *dayDate in week.allDateOfWeek) {
        NSMutableArray *dayArray = [NSMutableArray array];
        [dayArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getResultWithFilter:category forDay:dayDate]];
        if (dayArray.count > 0) {
            count += dayArray.count;
        }
    }
    return count;
}

- (NSInteger)getCategoryCountForMonth:(NSDate*)monthDate category:(NFNRsultCategory*)category {
    NSInteger count = 0;
    NSMutableArray *monthArray = [NSMutableArray array];
    [monthArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getResultWithFilter:category forMonth:monthDate]];
    if (monthArray.count > 0) {
        for (NSArray *dayArray in monthArray ) {
            count+=dayArray.count;
        }
    }
    return count;
  }

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    if (textLabelFrame.origin.x + textLabelFrame.size.width >= self.detailTextLabel.frame.origin.x) {
        textLabelFrame.size.width -= self.detailTextLabel.frame.size.width;
        self.textLabel.frame = textLabelFrame;
    }}




@end
