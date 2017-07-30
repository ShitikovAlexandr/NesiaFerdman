//
//  NFAddValueCategoryController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNValue.h"
#import "NFNManifestation.h"

@interface NFAddValueCategoryController : UIViewController
@property (strong, nonatomic) NFNValue *value;
@property (strong, nonatomic) NFNManifestation *manifestation;

@end
