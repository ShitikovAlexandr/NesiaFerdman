//
//  NFWeekDayView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#define LINE_COLOR [UIColor colorWithRed:238/255.0 green:239/255.0 blue:241/255.0 alpha:1]
#define TASK_CIRCLE_COLOR [UIColor colorWithRed:56/255.0 green:86/255.0 blue:237/255.0 alpha:1]


#import "NFWeekDayView.h"
@interface NFWeekDayView()

@end

@implementation NFWeekDayView



- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    self.layer.masksToBounds = YES;
    CGPoint startPoint = CGPointMake(CGRectGetWidth(self.frame)/2, 0);
    //NSLog(@"start point line %f", startPoint.x);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:CGPointMake(startPoint.x, CGRectGetHeight(self.frame))];
    CAShapeLayer *centerLine = [CAShapeLayer layer];
    centerLine.path = [path CGPath];
    centerLine.strokeColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:241/255.0 alpha:1].CGColor;
    centerLine.lineWidth = 1.5;
    [self.layer addSublayer:centerLine];
   }

- (void)addTaskButtonWithIndexPath:(NSIndexPath *)index {
   // [self addTaskCircle];
}

- (void)addTaskCircleToView:(NFWeekDayView*)view {
    [view layoutSubviews];
    CGFloat diametrOfTimeLinrPoint = 10.f;
    CGPoint starPoint = CGPointMake(CGRectGetWidth(view.bounds)/2 , view.bounds.size.height/2);

    //NSLog(@"start point %f", starPoint.x);
    view.circleLayer = [[CAShapeLayer alloc] init];
    view.circleLayer.frame = view.frame;
//    [view.circleLayer setBounds:CGRectMake(starPoint.x, starPoint.y,diametrOfTimeLinrPoint-2.0f, diametrOfTimeLinrPoint-2.0f)];
    [view.circleLayer setPosition:CGPointMake(CGRectGetWidth(view.frame)/2 - diametrOfTimeLinrPoint/2.f , view.frame.size.height/2)];
    UIBezierPath *pathCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(starPoint.x, starPoint.y,diametrOfTimeLinrPoint-2.0f, diametrOfTimeLinrPoint-2.0f)];
    [view.circleLayer setPath:[pathCircle CGPath]];
    [view.circleLayer setFillColor:[UIColor clearColor].CGColor];
    [view.circleLayer setStrokeColor:TASK_CIRCLE_COLOR.CGColor];
    [view.circleLayer setLineWidth:diametrOfTimeLinrPoint * 0.3];
    NSLog(@"view layer bounds %f", view.layer.bounds.size.width);
    NSLog(@"view layer frame %f", view.layer.frame.size.width);
    [view layoutIfNeeded];
    NSLog(@"view layer bounds after layoutIfNeeded %f", view.layer.bounds.size.width);
    NSLog(@"view layer frame after layoutIfNeeded %f", view.layer.frame.size.width);


    [view.layer addSublayer:self.circleLayer];
}


@end
