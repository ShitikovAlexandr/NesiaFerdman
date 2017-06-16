//
//  NFChackBox.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/2/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFChackBox.h"

@implementation NFChackBox

-  (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGRect newRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, 25.f, 25.f);
        self.frame = newRect;
        [self setImage:[UIImage imageNamed:@"checked_disable.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"checked_enable.png"] forState:UIControlStateSelected];
        self.selected = false;
        
        // then set stile of dutton in custom
    }
    return self;
}

@end
