//
//  NFDayView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDayView.h"

@interface NFDayView()
@property (assign, nonatomic) CGFloat offsetY;
@end


@implementation NFDayView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    self.offsetY = self.frame.size.height/2.f - self.circleRadius;
    self.circleLayer = [CAShapeLayer layer];
    [self.circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.offsetX, _offsetY, self.circleRadius*2, self.circleRadius*2)] CGPath]];
    [self.circleLayer setFillColor:[[UIColor lightGrayColor] CGColor]];
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:self.circleLayer];
    //[self addTimeLine];
    
}

- (void)addTimeLine {
    
    
    CGPoint starPoint = CGPointMake(self.offsetX + self.circleRadius*2.f,self.offsetY + self.circleRadius);
    CGFloat diametrOfTimeLinrPoint = 10.f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(starPoint.x + diametrOfTimeLinrPoint/2, starPoint.y)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.offsetY + self.circleRadius)];
    self.timeLineLayer = [CAShapeLayer layer];
    self.timeLineLayer.path = [path CGPath];
    self.timeLineLayer.strokeColor = [[UIColor greenColor] CGColor];
    self.timeLineLayer.lineWidth = 1.0;
    [self.layer addSublayer:self.timeLineLayer];
    
    self.circleLayerTineLine = [CAShapeLayer layer];
    [self.circleLayerTineLine setBounds:CGRectMake(starPoint.x, starPoint.y,diametrOfTimeLinrPoint-2.0f, diametrOfTimeLinrPoint-2.0f)];
    [self.circleLayerTineLine setPosition:starPoint];
    UIBezierPath *pathCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(starPoint.x, starPoint.y,diametrOfTimeLinrPoint-2.0f, diametrOfTimeLinrPoint-2.0f)];
    [self.circleLayerTineLine setPath:[pathCircle CGPath]];
    [self.circleLayerTineLine setFillColor:[UIColor clearColor].CGColor];
    [self.circleLayerTineLine setStrokeColor:[UIColor greenColor].CGColor];
    [self.circleLayerTineLine setLineWidth:diametrOfTimeLinrPoint * 0.2];
    [self.layer addSublayer:self.circleLayerTineLine];
}

- (void)removeTimeLine {
    [self.timeLineLayer removeFromSuperlayer];
}

- (void) addTimeLineWithIndexPath:(NSIndexPath *)index {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H"];
     //[dateFormatter stringFromDate:date];
    NSString *time = [NSString stringWithFormat:@"%ld", (long)index.row];
    if ([time isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
        [self addTimeLine];
    }
}


@end
