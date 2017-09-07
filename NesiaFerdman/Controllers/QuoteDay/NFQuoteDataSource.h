//
//  NFQuoteDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 9/7/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFNQuote.h"

@interface NFQuoteDataSource : NSObject

- (instancetype)initWithTableView:(UITableView*)tableView;
- (void)setQuote:(NFNQuote*)quote;

@end
