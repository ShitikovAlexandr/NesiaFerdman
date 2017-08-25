//
//  NFPickerView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/5/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFPickerView : UIPickerView

@property (strong, nonatomic) NSNumber *selectedIndex;
@property (strong, nonatomic) id lastSelectedItem;

- (instancetype) initWithDataArray:(NSArray *)array
                         textField:(UITextField *)textField
                          keyTitle:(NSString *)keyForTitle;

@end
