//
//  NFDayTableViewCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDayView.h"
#import "NFNEvent.h"

@interface NFDayTableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet NFDayView *drawView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTaskLabel;
@property (strong, nonatomic) NFNEvent *event;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet UIView *calendarColorView;


- (void) addData:(NSMutableArray *)events withIndexPath:(NSIndexPath *)index date:(NSDate*)currentDate ;



@end
