//
//  NFAnimatedLabel.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/16/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAnimatedLabel.h"

@implementation NFAnimatedLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionReveal;
        animation.duration = 1.0;
        [self.layer addAnimation:animation forKey:@"kCATransitionReveal"];
        self.text = @"0";

    }
    return self;

}
@end
