//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.


#import <UIKit/UIKit.h>

@interface NFNValue : NSObject

@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, strong) NSString * valueId;
@property (nonatomic, strong) NSString * valueImage;
@property (nonatomic, assign) NSInteger valueIndex;
@property (nonatomic, strong) NSString * valueTitle;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
