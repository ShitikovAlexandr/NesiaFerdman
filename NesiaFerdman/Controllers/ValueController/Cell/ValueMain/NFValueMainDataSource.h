//
//  NFValueMainDataSource.h
//  NesiaFerdman
//
//  Created by Alex on 30.07.17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPKeyboardAvoidingTableView.h"


@interface NFValueMainDataSource : NSObject

- (instancetype)initWithTableView:(TPKeyboardAvoidingTableView*)tableView target:(UIViewController*)target;
- (void)getData;
- (void)addNavigationButtons;

@end
