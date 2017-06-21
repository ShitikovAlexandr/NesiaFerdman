//
//  NFResult.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResult.h"
#import <objc/runtime.h>


@implementation NFResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.resultId = [dictionary objectForKey:@"resultId"];
        self.resultIndex = [dictionary objectForKey:@"resultIndex"];
        self.resultDescription = [dictionary objectForKey:@"resultDescription"];
        self.resultCategoryId = [dictionary objectForKey:@"resultCategoryId"];
        self.startDate = [dictionary objectForKey:@"startDate"];
    }
    return self;
}

- (NSDictionary *)convertToDictionary {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        if (value)
            [dictionary setObject:value forKey:key];
    }
    free(properties);
    return dictionary;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *newID = [[NSUUID UUID] UUIDString];
        self.resultId = newID;
        self.startDate = [NSString stringWithFormat:@"%@", [NSDate date]];
    }
    return self;
}



@end
