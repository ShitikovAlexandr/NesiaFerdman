//
//  NFEditTaskController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNEvent.h"

typedef NS_ENUM(NSUInteger, EditType)
{
    Edit,
    New
};

@interface NFEditTaskController : UITableViewController
@property (strong, nonatomic) NFNEvent *event;
@property (assign, nonatomic) EditType screenType;
@property (strong, nonatomic) NSDate *selectedDate;

@end
