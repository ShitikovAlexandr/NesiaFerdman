//
//  NFValue.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFValue : NSObject

@property (strong, nonatomic) NSString *valueTitle;
@property (strong, nonatomic) NSString *valueId;
@property (strong, nonatomic) NSNumber *valueIndex;
@property (strong, nonatomic) NSString *valueImage;
@property (assign, nonatomic) BOOL isDeleted;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)convertToDictionary;

@end
