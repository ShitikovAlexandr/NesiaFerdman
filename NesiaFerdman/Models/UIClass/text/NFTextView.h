//
//  NFTextView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/30/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFTextView : UITextView
@property (strong, nonatomic) NSString *placeholderText;

- (void)validateWithTarget:(id)target
           placeholderText:(NSString*)placeholderText
                       min:(NSInteger)min
                       max:(NSInteger)max;
- (BOOL)isValidString;



@end
