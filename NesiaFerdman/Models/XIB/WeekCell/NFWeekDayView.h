//
//  NFWeekDayView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFWeekDayView : UIView
@property (strong, nonatomic) CAShapeLayer *circleLayer;
@property (assign, nonatomic) BOOL isTask;

- (void)addTaskButtonWithIndexPath:(NSIndexPath *)index;
- (void)addTaskCircleToView:(NFWeekDayView*)view;

@end
