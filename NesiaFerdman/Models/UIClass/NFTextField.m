//
//  NFTextField.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/30/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTextField.h"
#import <ISMessages/ISMessages.h>
#import "NFStyleKit.h"

@interface NFTextField()
@property (strong, nonatomic) id target;
@property (assign, nonatomic) BOOL isShowAlert;
@property (assign, nonatomic) BOOL isValid;
@end

@implementation NFTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isValid = false;
    }
    return self;
}

- (void)validateWithTarget:(id)target placeholderText:(NSString*)placeholderText{
    self.target = target;
    self.placeholderText = placeholderText;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingValidation) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateText) name:UITextFieldTextDidChangeNotification object:nil];
}

- (BOOL)isValidString {
    [self endEditingValidation];
    [self setText: [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
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
        [self setValidAtributeString];
        self.textColor = [UIColor blackColor];
        self.isValid = true;
        _isShowAlert = false;
    }
}

- (void)endEditingValidation {
    [self setText: [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSString *massage = @"";
    if (self.text.length < 1) {
        massage = @"Строка не должна быть пустой";
        [self setErrorAtributeString];
        [self showAlertWithMasssage:massage];
        _isValid = false;
    }
    else {
        self.textColor = [UIColor blackColor];
        [self setValidAtributeString];
        _isValid = true;
    }
}

- (void)dealloc {
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)showAlertWithMasssage:(NSString*)massage {
    
//    [ISMessages showCardAlertWithTitle:massage
//                               message:nil
//                              duration:3.f
//                           hideOnSwipe:YES
//                             hideOnTap:YES
//                             alertType:ISAlertTypeError
//                         alertPosition:ISAlertPositionTop
//                               didHide:^(BOOL finished) {
//                                  _isShowAlert = false;
//                                   self.textColor = [UIColor blackColor];
//                               }];
    
    ISMessages* alert = [ISMessages cardAlertWithTitle:@""
                                               message:massage
                                             iconImage:[UIImage imageNamed:@"isInfoIconRed"]
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeCustom
                                         alertPosition:ISAlertPositionTop];
    
    
    alert.titleLabelFont = [UIFont boldSystemFontOfSize:15.f];
    alert.titleLabelTextColor = [UIColor redColor];
    
    //alert.messageLabelFont = [UIFont italicSystemFontOfSize:13.f];
    alert.messageLabelTextColor = [UIColor redColor];
    
    alert.alertViewBackgroundColor = [UIColor whiteColor];
    alert.view.clipsToBounds = NO;
    UIView *shadowView = [alert.view.subviews objectAtIndex:0];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowRadius = 2.f;
    shadowView.layer.shadowOpacity = 0.5;
    shadowView.layer.shadowOffset = CGSizeMake(0, 2);
    shadowView.layer.cornerRadius = 4.f;

    
    [alert show:^{
        NSLog(@"Callback is working!");
    } didHide:^(BOOL finished) {
        NSLog(@"Custom alert without image did hide.");
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
