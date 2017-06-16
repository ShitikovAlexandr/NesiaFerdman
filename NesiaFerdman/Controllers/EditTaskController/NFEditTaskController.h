//
//  NFEditTaskController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFEvent.h"

typedef NS_ENUM(NSUInteger, EditType)
{
    Edit,
    New
};

@interface NFEditTaskController : UITableViewController
@property (strong, nonatomic) NFEvent *event;
@property (assign, nonatomic) EditType screenType;

@end
