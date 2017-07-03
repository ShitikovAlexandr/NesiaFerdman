//
//  NFEditResultController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFResultCategory.h"
#import "NFResult.h"

@interface NFEditResultController : UIViewController
@property (strong, nonatomic) NFResultCategory *category;
@property (strong, nonatomic) NFResult *resultItem;
@property (strong, nonatomic) NSDate *selectedDate;


@end
