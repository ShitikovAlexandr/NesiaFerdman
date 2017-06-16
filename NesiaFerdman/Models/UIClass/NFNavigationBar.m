//
//  NFNavigationBar.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//
#import "NFNavigationBar.h"


const CGFloat navigationBarHeightIncrease = 48.f;

@implementation NFNavigationBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        
        
        self.barTintColor = [UIColor colorWithRed:43/255.0 green:154/255.0 blue:63/255.0 alpha:1];
        self.tintColor = [UIColor whiteColor];
        self.barStyle = UIBarStyleBlack;
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    // Set tittle position for top
    
    [self setTitleVerticalPositionAdjustment:-(navigationBarHeightIncrease) forBarMetrics:UIBarMetricsDefault];

}

- (CGSize)sizeThatFits:(CGSize)size {
    // Increase NavBar size
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height += navigationBarHeightIncrease;
    
    return amendedSize;
}

- (void)layoutSubviews {
    // Set buttons position for top
    [super layoutSubviews];
    
    NSArray *classNamesToReposition = @[@"UINavigationButton"];
    
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect frame = [view frame];
            frame.origin.y -= navigationBarHeightIncrease;
            
            [view setFrame:frame];
        }
    }
}

- (void)didAddSubview:(UIView *)subview
{
    // Set segmented position
    [super didAddSubview:subview];
    
    if ([subview isKindOfClass:[UISegmentedControl class]])
    {
        CGRect frame = subview.frame;
        frame.origin.y += navigationBarHeightIncrease;
        subview.frame = frame;
    }
}



@end
