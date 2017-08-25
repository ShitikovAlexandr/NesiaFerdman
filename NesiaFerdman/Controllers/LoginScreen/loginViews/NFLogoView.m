//
//  NFLogoView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFLogoView.h"
#import "NFStyleKit.h"

@implementation NFLogoView

- (void)drawRect:(CGRect)rect {
    [NFStyleKit drawLogoCircleWithFrame:rect];
}

@end
