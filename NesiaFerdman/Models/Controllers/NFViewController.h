//
//  NFViewController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/13/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFSegmentedControl.h"
#import "NFTaskManager.h"
#import "NFNEvent.h"


@interface NFViewController : UIViewController

//@property (strong, nonatomic) NFSegmentedControl *segmentedControl;

//- (void)addButtonAction;
//
//
//- (IBAction)pressSegment:(UISegmentedControl *)sender;

//- (void)filterAction;

- (void)navigateToFilterScreen;
- (void)navigateToEditTaskScreenWithEvent:(NFNEvent*)event;
//- (void)navigateToGoogleCalendarScreen;
@end
