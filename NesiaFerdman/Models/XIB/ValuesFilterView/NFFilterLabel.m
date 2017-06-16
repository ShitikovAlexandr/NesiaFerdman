//
//  NFFilterLabel.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/30/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFFilterLabel.h"

@implementation NFFilterLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 10, 0, 30};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
