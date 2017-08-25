//
//  NFLabel.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFLabel.h"
#import "NFStyleKit.h"

@implementation NFLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //// Rectangle Drawing
    CGFloat newWidth = rect.size.width/3.0;
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(rect.size.width/2 - newWidth/2, rect.size.height - 6, newWidth, 2.0)];
    [NFStyleKit.bASE_GREEN setFill];
    [rectanglePath fill];
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 1.0;
    [self.layer addAnimation:animation forKey:@"kCATransitionFade"];
}

@end
