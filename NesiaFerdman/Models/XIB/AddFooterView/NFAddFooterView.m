//
//  NFAddFooterView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/9/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAddFooterView.h"
#import "NFStyleKit.h"

@interface NFAddFooterView()

@end

@implementation NFAddFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpConstraints];
        
    }
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpConstraints];
}

#pragma mark - Default setup -

- (void)setDefaultValues {
    _addButton = [UIButton new];
//    [_addButton setImage:[UIImage imageNamed:@"Add.png"] forState:UIControlStateNormal];
//    _addButton.translatesAutoresizingMaskIntoConstraints = NO;
    _textField = [[UITextField alloc] init];
//    uint padding = 10;//padding for iOS7
    UIImageView * iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Add.png"]];
    iconImageView.frame = CGRectMake(0, 0, 16, 16);
    _textField.clipsToBounds = YES;
    _textField.leftView = iconImageView;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    [_textField setLeftViewMode:UITextFieldViewModeUnlessEditing];
    [self addSubview:_textField];
}

#pragma mark - Constraints -

- (void)setUpConstraints {
    [self setDefaultValues];
    
    NSArray<NSLayoutConstraint*> *constraints = @[[NSLayoutConstraint
                                                  constraintWithItem:self.textField
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0
                                                   constant:18.0],
                                                  [NSLayoutConstraint
                                                   constraintWithItem:self.textField
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeCenterY
                                                   multiplier:1.0
                                                   constant:0],
                                                  [NSLayoutConstraint
                                                   constraintWithItem:self.textField
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1.0
                                                   constant:300.0],
                                                  [NSLayoutConstraint
                                                   constraintWithItem:self.textField
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1.0
                                                   constant:30.0]
                                                 ];
    [self addConstraints:constraints];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [NFStyleKit drawDownBorderWithView:self withOffset:18.0];
    [NFStyleKit drawTopBorderWithView:self withOffset:0];
}

@end
