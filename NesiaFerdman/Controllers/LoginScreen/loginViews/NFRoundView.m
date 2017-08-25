//
//  NFRoundView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFRoundView.h"
#import "NFStyleKit.h"

@implementation NFRoundView


- (void)drawRect:(CGRect)rect {
    //[NFStyleKit drawRoundetViewWithFrame:rect];
    
    UIImageView *loginImageView = [[UIImageView alloc] initWithFrame:rect];
    loginImageView.contentMode = UIViewContentModeScaleAspectFill;
    [loginImageView setImage:[UIImage imageNamed:@"splashBig.png"]];
    [self addSubview:loginImageView];

}



@end
