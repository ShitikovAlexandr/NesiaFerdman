//
//  NFProgressShapeLayer.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFProgressShapeLayer.h"

@implementation NFProgressShapeLayer

- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"strokeEnd"]) {
        return [self makeAnimationForKey:event];
    } else  {
        return [super actionForKey:event];
    }
}

- (CABasicAnimation *)makeAnimationForKey:(NSString *)key {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 1.f;
    return animation;
}


@end
