//
//  NFCalendarListDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NFCalendarListDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target;
- (void)updateData;

@end
