//
//  NFQuoteDay.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFQuoteDay.h"

@implementation NFQuoteDay

- (id)initTestData {
    self = [super init];
    if (self) {
        self.quote = @" 'Каждый человек уникален в своем человеческом предназначении, потому его существование обладает абсолютной ценностью, не зависящей ни от чего внешнего.'";
        self.autor = @"Гилель";
    }
    return self;
}

@end
