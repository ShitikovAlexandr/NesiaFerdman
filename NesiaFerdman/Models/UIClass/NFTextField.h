//
//  NFTextField.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/30/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFTextField : UITextField 
@property (strong, nonatomic) NSString *placeholderText;

- (void)validateWithTarget:(id)target placeholderText:(NSString*)placeholderText;
- (BOOL)isValidString;

@end
