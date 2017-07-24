//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import <UIKit/UIKit.h>

@interface NFNRsultCategory : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * title;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;

@end
