//
//  NFValue.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFManifestation.h"

@interface NFValue : NSObject

@property (strong, nonatomic) NSString *valueTitle;
@property (strong, nonatomic) NSString *valueId;
@property (strong, nonatomic) NSNumber *valueIndex;
@property (strong, nonatomic) NSString *valueImage;
@property (assign, nonatomic) BOOL isDeleted;
@property (strong, nonatomic) NSMutableArray* manifestations;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)convertToDictionary;
- (id) copyWithZone: (NSZone *) zone;

@end
