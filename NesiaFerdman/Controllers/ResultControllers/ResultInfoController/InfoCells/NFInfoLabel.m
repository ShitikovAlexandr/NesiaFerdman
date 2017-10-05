//
//  NFInfoLabel.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 10/5/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFInfoLabel.h"

@implementation NFInfoLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(5.0, 0, 5.0, 0);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];

}


@end
