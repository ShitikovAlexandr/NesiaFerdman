//
//  NFWeekTaskCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFWeekDayView.h"

@interface NFWeekTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutletCollection(NFWeekDayView) NSArray *dayViewArray;


- (void)addDataWithEventsArray:(NSMutableArray *)eventsArray indexPath:(NSIndexPath *)index;


@end
