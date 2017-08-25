//
//  NFRegisterTextField.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/25/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFRegisterTextField.h"
#import "NFStyleKit.h"

@interface NFRegisterTextField ()

@end

@implementation NFRegisterTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    self.borderStyle = UITextBorderStyleNone;

    _activeColor = [NFStyleKit bASE_GREEN];
    _disactiveColor = [UIColor lightGrayColor];
    self.lineColor = _disactiveColor;
    self.selectedLineColor = _activeColor;
    self.placeHolderColor = _disactiveColor;
    self.selectedPlaceHolderColor = _activeColor;
    
    
    
}

@end
