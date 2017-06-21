//
//  NFResult.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFResult : NSObject

@property (strong, nonatomic) NSString* resultDescription;
@property (strong, nonatomic) NSString* resultId;
@property (strong, nonatomic) NSNumber* resultIndex;
@property (strong, nonatomic) NSString *resultCategoryId;
@property (strong, nonatomic) NSString *startDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)convertToDictionary;



@end
