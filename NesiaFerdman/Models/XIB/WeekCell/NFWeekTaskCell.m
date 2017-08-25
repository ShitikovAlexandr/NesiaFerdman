//
//  NFWeekTaskCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//
#define LINE_COLOR [UIColor colorWithRed:238/255.0 green:239/255.0 blue:241/255.0 alpha:1]


#import "NFWeekTaskCell.h"
#import "NFEvent.h"

@interface NFWeekTaskCell()
@property (assign, nonatomic) CGFloat offsetY;
@property (assign, nonatomic) BOOL isCurrentTime;
@property (assign, nonatomic) BOOL isSecondCall;
@end

@implementation NFWeekTaskCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:241/255.0 alpha:1].CGColor;
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1.5);
    [self.layer addSublayer:upperBorder];}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.layer.cornerRadius = self.timeLabel.frame.size.height/2;
    self.timeLabel.layer.masksToBounds =YES;
    self.timeLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:241/255.0 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)prepareForReuse {
    for (NFWeekDayView *view in self.dayViewArray) {
        view.isTask = NO;
        [view.circleLayer removeFromSuperlayer];
    }
}

- (void)addDataWithEventsArray:(NSMutableArray *)eventsArray indexPath:(NSIndexPath *)index {
    if (eventsArray.count > 0) {
        int i = -1;
        for (NSMutableArray *tasks in eventsArray) {
            i++;
            if (tasks.count > 0) {
                
                
                // NSMutableArray *tasks = [NSMutableArray arrayWithArray:[eventsArray objectAtIndex:i]];
                NSMutableArray *result = [NSMutableArray array];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.startDate contains[c] %@",[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"T%02ld", (long)index.row]]];
                [result addObjectsFromArray:[tasks filteredArrayUsingPredicate:predicate]];
                if (result.count > 0) {
                    [(NFWeekDayView *)[self.dayViewArray objectAtIndex:i] addTaskCircleToView:(NFWeekDayView *)[self.dayViewArray objectAtIndex:i]];
                    //                NFWeekDayView *view = [self.dayViewArray objectAtIndex:i];
                    //                view.isTask = YES;
                }
            }
        }
    }
}

@end
