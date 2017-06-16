//
//  NFProgressView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFProgressView.h"
#import "NFStyleKit.h"

@implementation NFProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressLayer = [NFProgressShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, self.frame.size.height/2.0)];
    [linePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2.0)];
    self.progressLayer.path = linePath.CGPath;
    self.progressLayer.lineWidth = self.frame.size.height;
    self.progressLayer.strokeColor = _progressColor.CGColor;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.borderWidth = 0.5;
    self.progressLayer.cornerRadius = self.frame.size.height/2.0;
    self.progressLayer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.progressLayer.lineCap = kCALineCapRound;
    
    self.progressLayer.masksToBounds = YES;
    
    [self.layer addSublayer:self.progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
}
@end
