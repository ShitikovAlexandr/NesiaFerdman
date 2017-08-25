//
//  NFLoginSimpleDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/25/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFLoginSimpleController.h"


@interface NFLoginSimpleDataSource : NSObject

- (instancetype)initWithTarget:(NFLoginSimpleController*)target;
- (void)navigateToTutorial;

@end
