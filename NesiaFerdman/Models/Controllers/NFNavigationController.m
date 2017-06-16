//
//  NFNavigationController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFNavigationController.h"
#import "NFNavigationBar.h"
#import "NotifyList.h"

@interface NFNavigationController () 
@end

@implementation NFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Календарь";

}



- (void)addButtonAction {
    NSLog(@"press add");
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}


@end
