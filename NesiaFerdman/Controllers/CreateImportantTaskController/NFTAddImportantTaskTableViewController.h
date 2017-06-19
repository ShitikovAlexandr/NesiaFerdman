//
//  NFTAddImportantTaskTableViewController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/5/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFEvent.h"

@interface NFTAddImportantTaskTableViewController : UITableViewController

@property (assign ,nonatomic) EventType eventType;
@property (strong, nonatomic) NFEvent *event;

@end
