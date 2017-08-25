//
//  NFCalendar.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFCalendar.h"

@implementation NFCalendar

- (id)initWithGregorianUTC {
    self = [super initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    if (self) {
        [self setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    return self;
}


@end
