//
//  NFSegmentedControl.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/13/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSegmentedControl.h"

@implementation NFSegmentedControl

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 6.f;
        self.layer.borderWidth = -1.f;
        self.backgroundColor = [UIColor colorWithRed:35/255.0 green:127/255.0 blue:53/255.0 alpha:1];
        self.tintColor = [UIColor colorWithRed:31/255.0 green:111/255.0 blue:47/255.0 alpha:1];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
