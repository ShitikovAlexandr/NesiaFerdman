//
//  NFResultCategory.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFResultCategory : NSObject
@property (strong, nonatomic) NSString* resultCategoryTitle;
@property (strong, nonatomic) NSString* resultCategoryId;
@property (strong, nonatomic) NSNumber* resultCategoryIndex;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)convertToDictionary;


@end
