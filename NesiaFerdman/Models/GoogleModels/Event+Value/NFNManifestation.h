//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import <UIKit/UIKit.h>

@interface NFNManifestation : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString * createDate;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * parentId;
@property (nonatomic, strong) NSString * title;
@property (assign, nonatomic) BOOL isDeleted;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
