//
//  NFLoginSimpleController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFLoginSimpleController : UIViewController

+ (NFLoginSimpleController *)sharedMenuController;

- (void)logout;
- (void) transformToLogin;

@end


