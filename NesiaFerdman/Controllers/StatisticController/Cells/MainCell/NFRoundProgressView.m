//
//  NFRoundProgressView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/16/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

#import "NFRoundProgressView.h"
#import "NFStyleKit.h"

@implementation NFRoundProgressView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    NSShadow* shadow2 = [[NSShadow alloc] init];
    shadow2.shadowColor = [UIColor.blackColor colorWithAlphaComponent: 0.75];
    shadow2.shadowOffset = CGSizeMake(0, 0);
    shadow2.shadowBlurRadius = 3;


    UIBezierPath* ovalPathBase = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 - 10 startAngle:0 endAngle:270 clockwise:YES];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2.shadowOffset, shadow2.shadowBlurRadius, [shadow2.shadowColor CGColor]);

    [[NFStyleKit _base_GREY] setStroke];
    [[UIColor whiteColor] setFill];
    ovalPathBase.lineWidth = 16;

    [ovalPathBase fill];
    [ovalPathBase stroke];
    CGContextRestoreGState(context);


    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 - 10 startAngle:0 endAngle:270 clockwise:YES];
    [[NFStyleKit _borderDarkGrey] setStroke];
    ovalPath.lineWidth = 8;
    [ovalPath stroke];
    
    //self.layer.cornerRadius = self.frame.size.height/2;
    //self.layer.masksToBounds = YES;
    
    
    

    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    CAShapeLayer *mainCircleLayer = [CAShapeLayer layer];
//    mainCircleLayer.frame = self.bounds;
//    //// Oval Drawing
//    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 - 10 startAngle:0 endAngle:270 clockwise:YES];
//;
//    mainCircleLayer.path = ovalPath.CGPath;
//    mainCircleLayer.lineWidth = 20;
//    mainCircleLayer.strokeColor = [NFStyleKit _base_GREY].CGColor;
//    mainCircleLayer.strokeStart = 0;
//    mainCircleLayer.strokeEnd = 1;
//    mainCircleLayer.fillColor = [UIColor whiteColor].CGColor;
//    [self.layer addSublayer:mainCircleLayer];
    
    self.progressLayer = [NFProgressShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    UIBezierPath* progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 - 10 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    self.progressLayer.path = progressPath.CGPath;
    self.progressLayer.lineWidth = 8;
    self.progressLayer.strokeColor = [UIColor orangeColor].CGColor;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.masksToBounds = YES;
    [self.layer addSublayer:self.progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressLayer.frame = self.bounds;
    UIBezierPath* progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 - 10 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    self.progressLayer.path = progressPath.CGPath;
}


@end
