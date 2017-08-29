//
//  NFAboutDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/29/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAboutDataSource.h"

@implementation NFAboutDataSource

- (void)linkAction:(NSString*)link {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}



@end
