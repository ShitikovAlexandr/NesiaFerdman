//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import <UIKit/UIKit.h>

@interface NFNGoogleEvent : NSObject

@property (nonatomic, strong) NSString * calendarId;
@property (nonatomic, strong) NSString * created;
@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, strong) NSString * end;
@property (nonatomic, strong) NSString * etag;
@property (nonatomic, strong) NSString * htmlLink;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger sequence;
@property (nonatomic, strong) NSString * start;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * updated;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;

@end
