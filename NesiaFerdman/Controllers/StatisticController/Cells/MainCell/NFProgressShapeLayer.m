//
//  NFProgressShapeLayer.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/14/17.
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
    if (_isDisableAnimation) {
        animation.duration = 0.0001;
    } else {
        animation.duration = 0.8;
    }
    return animation;
}


@end
