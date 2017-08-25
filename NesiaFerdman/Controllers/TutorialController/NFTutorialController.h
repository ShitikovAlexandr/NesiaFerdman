//
//  NFTutorialController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFTutorialController : UIViewController
@property (strong, nonatomic) UIViewController *nextController;
@property (assign, nonatomic) BOOL isFirstRun;

@end
