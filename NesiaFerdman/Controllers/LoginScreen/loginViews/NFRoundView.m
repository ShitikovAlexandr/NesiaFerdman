//
//  NFRoundView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFRoundView.h"
#import "NFStyleKit.h"

@implementation NFRoundView


- (void)drawRect:(CGRect)rect {
    [NFStyleKit drawRoundetViewWithFrame:rect];
}


@end
