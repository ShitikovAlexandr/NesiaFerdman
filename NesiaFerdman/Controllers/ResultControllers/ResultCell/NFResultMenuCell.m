//
//  NFResultMenuCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultMenuCell.h"
#import "NFTaskManager.h"

@implementation NFResultMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithDefaultStyle {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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

- (void)addDataToCell:(NFResultCategory*)category date:(NFWeekDateModel*)currentDate {
    [self animateLabel:self.detailTextLabel];
    self.textLabel.text = category.resultCategoryTitle;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%i", [self getCategoryCountForWeek:currentDate category:category]];

}


- (NSInteger)getCategoryCountForWeek:(NFWeekDateModel*)week category:(NFResultCategory*)category {
    NSInteger count = 0;
    for (NSDate *dayDate in week.allDateOfWeek) {
        NSMutableArray *dayArray = [NSMutableArray array];
        [dayArray addObjectsFromArray:[[NFTaskManager sharedManager] getResultWithFilter:category forDay:dayDate]];
        if (dayArray.count > 0) {
            count += dayArray.count;
        }
    }
    return count;
}


@end
