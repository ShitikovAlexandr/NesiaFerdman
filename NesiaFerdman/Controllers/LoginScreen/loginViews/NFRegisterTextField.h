//
//  NFRegisterTextField.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/25/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <ACFloatingTextField.h>

@interface NFRegisterTextField : ACFloatingTextField
@property (strong , nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *activeColor;
@property (strong, nonatomic) UIColor *disactiveColor;
@property (strong, nonatomic) NSString* textHolder;


//- (void)setEditingColor;

@end
