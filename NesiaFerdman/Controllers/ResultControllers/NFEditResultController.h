//
//  NFEditResultController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNRsultCategory.h"
#import "NFNRsult.h"

@interface NFEditResultController : UIViewController
@property (strong, nonatomic) NFNRsultCategory *category;
@property (strong, nonatomic) NFNRsult *resultItem;
@property (strong, nonatomic) NSDate *selectedDate;


@end
