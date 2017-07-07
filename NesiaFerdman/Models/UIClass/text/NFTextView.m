//
//  NFTextView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/30/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTextView.h"
#import <ISMessages/ISMessages.h>
#import "NFStyleKit.h"
#import <UITextView+Placeholder.h>

@interface NFTextView ()
@property (strong, nonatomic) id target;
@property (assign, nonatomic) BOOL isShowAlert;
@property (assign, nonatomic) BOOL isValid;
@property (assign, nonatomic) NSInteger minValue;
@property (assign, nonatomic) NSInteger maxValue;
@end

@implementation NFTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isValid = true;
    }
    return self;
}

- (void)validateWithTarget:(id)target
           placeholderText:(NSString*)placeholderText
                       min:(NSInteger)min
                       max:(NSInteger)max {
    self.target = target;
    self.placeholderText = placeholderText;
    self.minValue = min;
    self.maxValue = max;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingValidation) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateText) name:UITextViewTextDidChangeNotification object:nil];
}

- (BOOL)isValidString {
    if (_minValue > 0) {
        [self endEditingValidation];
    }
    [self setText: [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return _isValid;
    
}
- (void)validateText {
    NSString *massage = @"";
    if (self.text.length > _maxValue) {
        [self setText:[self.text substringToIndex:_maxValue]];
        if (!_isShowAlert) {
            massage = [NSString stringWithFormat:@"Количество символов не должно превышать %li", (long)_maxValue];
            [self showAlertWithMasssage:massage];
            self.isShowAlert = true;
        }
        self.textColor = [UIColor redColor];
        _isValid = true;
    } else {
        [self setValidAtributeString];
        self.textColor = [UIColor blackColor];
        _isShowAlert = false;
        _isValid = true;
    }
}

- (void)endEditingValidation {
    [self setText: [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];    NSString *massage = @"";
    if (self.text.length < 1) {
        [self setText:@""];
        massage = @"Строка не должна быть пустой";
        [self setErrorAtributeString];
        [self showAlertWithMasssage:massage];
        _isValid = false;
    }
    else {
//        [self setText: [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        self.textColor = [UIColor blackColor];
        [self setValidAtributeString];
        _isValid = true;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
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

- (void)setErrorAtributeString {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:_placeholderText attributes:@{ NSForegroundColorAttributeName : [UIColor redColor]}];
    self.attributedPlaceholder = str;
}

- (void)setValidAtributeString {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:_placeholderText attributes:@{ NSForegroundColorAttributeName : [NFStyleKit _PLACEHOLDER_STANDART_COLOR]}];
    self.attributedPlaceholder = str;
}

@end
