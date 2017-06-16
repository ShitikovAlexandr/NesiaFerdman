//
//  NFCircleView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFCircleView.h"
#import "NFStyleKit.h"

@implementation NFCircleView


- (void)drawRect:(CGRect)rect {
    [NFStyleKit drawCircleWithFrame:rect];
}

@end
