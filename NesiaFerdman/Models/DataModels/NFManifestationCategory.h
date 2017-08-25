//
//  NFManifestationCategory.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/26/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFManifestationCategory : NSObject

@property (strong, nonatomic) NSString* manifestationCategoryTitle;
@property (strong, nonatomic) NSString* manifestationCategoryId;
@property (strong, nonatomic) NSNumber* manifestationCategoryIndex;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)convertToDictionary;

@end
