//
//  NFDayView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDayView : UIView

@property (strong, nonatomic) CAShapeLayer *circleLayer;
@property (strong, nonatomic) CAShapeLayer *timeLineLayer;
@property (strong, nonatomic) CAShapeLayer *circleLayerTineLine;

@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat circleRadius;

- (void)addTimeLine;

- (void)addTimeLineWithIndexPath:(NSIndexPath *)index;

@end
