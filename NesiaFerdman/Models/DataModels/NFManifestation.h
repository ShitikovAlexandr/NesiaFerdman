//
//  NFManifestation.h
//  NesiaFerdman
//
//  Created by alex on 25.06.17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFManifestation : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *manifestationId;
@property (strong, nonatomic) NSNumber *index;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary *)convertToDictionary;

@end
