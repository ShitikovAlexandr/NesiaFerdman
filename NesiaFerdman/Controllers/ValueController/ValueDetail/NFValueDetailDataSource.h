//
//  NFValueDetailDataSource.h
//  NesiaFerdman
//
//  Created by Alex on 30.07.17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFNManifestation.h"
#import "NFValueDetailController.h"


@interface NFValueDetailDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView target:(NFValueDetailController*)target;

- (void)initButtons;
- (void)getData;

@end
