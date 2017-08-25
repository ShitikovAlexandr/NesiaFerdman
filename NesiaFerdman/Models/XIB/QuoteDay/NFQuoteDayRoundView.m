//
//  NFQuoteDayRoundView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFQuoteDayRoundView.h"

@implementation NFQuoteDayRoundView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}

- (void)layoutSubviews {
    self.invertIndex = 0.022;
    [self elipseOneSideWithInvertIndex:self.invertIndex];
}

- (void)elipseOneSideWithInvertIndex: (CGFloat)invertIndex {
    
    self.clipsToBounds = YES;
    CGFloat curveRadius = self.frame.size.width * invertIndex;
    CGFloat invertedRadius = 1.0/curveRadius;
    UIBezierPath *ellipticalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width + 2 * invertedRadius * self.frame.size.width, self.frame.size.height * 0.9)];
    [ellipticalPath applyTransform:CGAffineTransformMakeTranslation(-self.frame.size.width * invertedRadius, 0)];
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:self.frame];
    [rectanglePath applyTransform:CGAffineTransformMakeTranslation(0, (-self.frame.size.height * 0.9) * 0.5)];
    [ellipticalPath appendPath:rectanglePath];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.frame;
    maskLayer.path = ellipticalPath.CGPath;
    maskLayer.shadowColor = [UIColor blackColor].CGColor;
    maskLayer.shadowRadius = 10.f;
    maskLayer.shadowOpacity = 0.5;
    maskLayer.shadowOffset = CGSizeMake(0, 10.f);
    self.layer.mask = maskLayer;
}


@end
