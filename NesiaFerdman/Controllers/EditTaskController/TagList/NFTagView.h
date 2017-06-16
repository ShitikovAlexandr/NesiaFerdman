//
//  NFTagView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/2/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFValue.h"


@interface NFTagView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (instancetype)initWithText:(NSString *)text andPoint:(CGPoint)position;

- (CGFloat)calculateSizeWithText:(NSString*)text andMainView:(UIView *)view;

@end
