//
//  NFDatePicker.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/5/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFDatePicker : UIDatePicker
@property (strong, nonatomic) NSDate *selectedDate;
@property (assign, nonatomic) BOOL onlyDate;

- (instancetype)initWithTextField:(UITextField *)textField;

@end
