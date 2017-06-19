//
//  NFStatisticMainCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticMainCell.h"
#import "NFProgressView.h"
#import "NFStyleKit.h"
#import "NFTaskManager.h"
#import "NFEvent.h"

@interface NFStatisticMainCell()
@property (weak, nonatomic) IBOutlet UIImageView *valieImage;
@property (weak, nonatomic) IBOutlet UILabel *valueTitle;
@property (weak, nonatomic) IBOutlet UILabel *realTaskLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneTaskLabel;
@property (weak, nonatomic) IBOutlet UILabel *realTaskCount;
@property (weak, nonatomic) IBOutlet UILabel *doneTaskCount;
@property (weak, nonatomic) IBOutlet UIImageView *doneTaskchackBoxImage;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet NFProgressView *realTaskProgressView;
@property (weak, nonatomic) IBOutlet NFProgressView *doneTaskProgressView;

@end

@implementation NFStatisticMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _realTaskProgressView.progressColor = [NFStyleKit _borderDarkGrey];
    _doneTaskProgressView.progressColor = [NFStyleKit bASE_GREEN];
    _footerView.backgroundColor = [NFStyleKit _base_GREY];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addDatatoCellwithDictionary:(NSMutableDictionary*)inputDic indexPath:(NSIndexPath*)indexPath {
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([NFTaskManager sharedManager].selectedValuesArray.count > 0 ) {
        [dataArray addObjectsFromArray:[NFTaskManager sharedManager].selectedValuesArray];
    } else {
        [dataArray addObjectsFromArray:[NFTaskManager sharedManager].valuesArray];
    }
    NSString *key;
    if (indexPath.section == dataArray.count) {
        key = @"other";
        self.valueTitle.text = @"Другое";
        [_valieImage setImage:[UIImage imageNamed:@"response-value45.png"]];
    } else {
        NFValue *value = [dataArray objectAtIndex:indexPath.section];
        self.value = value;
        if (value.valueImage) {
            [_valieImage setImage:[UIImage imageNamed:value.valueImage]];
        } else {
            [_valieImage setImage:[UIImage imageNamed:@"response-value45.png"]];
        }
        key = value.valueTitle;
        self.valueTitle.text = key;
    }
    NSMutableArray *taskArray = [NSMutableArray array];
    [taskArray  addObjectsFromArray:[inputDic valueForKey:key]];
    _realTaskCount.text = [NSString stringWithFormat:@"%ld", taskArray.count];
    if (!taskArray.count) {
        [self setAlltaskToZero];
    } else {
        [self setRealLevelToMax];
        [self setDoneLevelWithValue:[self doneValueWithTaskArray:taskArray]];
    }
    
    
}

- (void)setDoneLevelWithValue:(CGFloat)value {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //self.realTaskProgressView.progressLayer.strokeEnd = 1;
        self.doneTaskProgressView.progressLayer.strokeEnd = value;
    });
}
- (void)setRealLevelToMax {
    self.realTaskProgressView.progressLayer.strokeEnd = 1;
}

-(void)setAlltaskToZero {
    self.realTaskProgressView.progressLayer.strokeEnd = 0;
    self.doneTaskProgressView.progressLayer.strokeEnd = 0;
    self.doneTaskCount.text = @"0";
    self.realTaskCount.text = @"0";
    
}

-(void)setDoneCountWithValue:(NSInteger)val {
    self.doneTaskCount.text = [NSString stringWithFormat:@"%ld", val];
}

- (CGFloat)doneValueWithTaskArray:(NSMutableArray*)taskArray {
    int done = 0;
    int allTasks = 0;
    for (NFEvent *event in taskArray) {
        allTasks++;
        if (event.isDone) {
            done++;
        }
        [self setDoneCountWithValue:done];
        if (done > 0 ) {
            [self isTaskChacked:true];
        } else {
            [self isTaskChacked:false];
        }
    }
    _eventCount = allTasks;
    CGFloat result = (1.0/(CGFloat)taskArray.count) * done;
    return result;
}

- (void)prepareForReuse {
    self.doneTaskCount.text = @"0";
    self.realTaskCount.text = @"0";
    [self isTaskChacked:false];
    self.value = nil;
    self.eventCount = 0;
}

- (void)isTaskChacked:(BOOL)chack {
    if (chack) {
        [self.doneTaskchackBoxImage setImage:[UIImage imageNamed:@"checked_enable.png"]];
    } else {
        [self.doneTaskchackBoxImage setImage:[UIImage imageNamed:@"checked_disable.png"]];
    }
}


@end

