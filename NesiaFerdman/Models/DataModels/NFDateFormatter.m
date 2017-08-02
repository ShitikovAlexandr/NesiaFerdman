//
//  NFDateFormatter.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDateFormatter.h"

@implementation NFDateFormatter

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
        [self setLocale: loc];
       // [self setTimeZone:[NSTimeZone systemTimeZone]];
        
            }
    return self;
}



@end
