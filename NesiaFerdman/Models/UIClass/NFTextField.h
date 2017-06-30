//
//  NFTextField.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/30/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TextFieldType)
{
    Title,
    Description,
    Email
};

@interface NFTextField : UITextField 
@property (assign, nonatomic) BOOL isValid;

- (void)validateWithTarget:(id)target;

//@property (assign, nonatomic) NSInteger minLenght;
//@property (assign, nonatomic) NSInteger maxLenght;
//@property (assign, nonatomic) TextFieldType type;



@end
