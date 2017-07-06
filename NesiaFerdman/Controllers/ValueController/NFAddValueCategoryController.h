//
//  NFAddValueCategoryController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFValue.h"
#import "NFManifestation.h"



@interface NFAddValueCategoryController : UIViewController
@property (strong, nonatomic) NFValue *value;
@property (strong, nonatomic) NFManifestation *manifestation;

@end
