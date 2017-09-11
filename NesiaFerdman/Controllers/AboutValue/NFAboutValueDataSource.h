//
//  NFAboutValueDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 9/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFAboutValueInfoController.h"


@interface NFAboutValueDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView target:(NFAboutValueInfoController*)target;

@end
