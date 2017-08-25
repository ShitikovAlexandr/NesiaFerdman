//
//  NFRoundButton.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFRoundButton.h"

@implementation NFRoundButton


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 2.f;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2.f, 2.f);
    }
    return self;
}

- (void)setLoginGoogleButtonStyle {
    self.backgroundColor = [UIColor colorWithRed:220/255.0 green:69/255.0 blue:47/255.0 alpha:1];
    NSString *googleTitle = [NSString stringWithFormat:@"Google +"];
    [self setTitle:googleTitle forState:UIControlStateNormal];
}
@end
