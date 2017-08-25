//
//  NFValueController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ValueScreenState)
{
    ViewValue,
    EditValue,
    FirstRunValue
};


@interface NFValueController : UIViewController
@property (assign, nonatomic) BOOL isFirstRun;
@property (assign, nonatomic) ValueScreenState screenState;
@property (strong, nonatomic) UIViewController *nextController;

@end
