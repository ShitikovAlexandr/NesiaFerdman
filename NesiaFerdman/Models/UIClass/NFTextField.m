//
//  NFTextField.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/30/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTextField.h"
#import <ISMessages/ISMessages.h>


@interface NFTextField()
@property (strong, nonatomic) id target;
@property (assign, nonatomic) BOOL isShowAlert;

@end


@implementation NFTextField

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isValid = false;
    }
    return self;
}

- (void)validateWithTarget:(id)target {
    self.target = target;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingValidation) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateText) name:UITextFieldTextDidChangeNotification object:nil];
}

- (BOOL)isValidString {
    [self endEditingValidation];
    return _isValid;
    
}
- (void)validateText {
    NSString *massage = @"";
    if (self.text.length > 80) {
        [self setText:[self.text substringToIndex:80]];
        if (!_isShowAlert) {
            massage = @"Количество символов не должно превышать 80";
            [self showAlertWithMasssage:massage];
            self.isShowAlert = true;
        }
        self.textColor = [UIColor redColor];
        _isValid = false;
    } else {
        self.textColor = [UIColor blackColor];
        _isShowAlert = false;
    }
    NSLog(@"validate");
}

- (void)endEditingValidation {
    [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *massage = @"";
    if (self.text.length < 1) {
        massage = @"Строка не должна быть пустой";
        self.textColor = [UIColor redColor];
        [self showAlertWithMasssage:massage];
        _isValid = false;
    } else if (self.text.length > 80) {
        [self setText:[self.text substringToIndex:79]];
        self.textColor = [UIColor redColor];
        _isValid = false;
        massage = @"Количество символов не должно превышать 80";
        [self showAlertWithMasssage:massage];

    } else {
        self.textColor = [UIColor blackColor];
        _isValid = true;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)showAlertWithMasssage:(NSString*)massage {
    
    [ISMessages showCardAlertWithTitle:massage
                               message:nil
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeError
                         alertPosition:ISAlertPositionTop
                               didHide:^(BOOL finished) {
                                  _isShowAlert = false;
                                   self.textColor = [UIColor blackColor];
                               }];
}

@end
