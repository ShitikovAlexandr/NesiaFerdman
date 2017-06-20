//
//  NFResultCategory.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultCategory.h"
#import <objc/runtime.h>


@implementation NFResultCategory

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.resultCategoryId = [dictionary objectForKey:@"resultCategoryId"];
        self.resultCategoryIndex = [dictionary objectForKey:@"resultCategoryIndex"];
        self.resultCategoryTitle = [dictionary objectForKey:@"resultCategoryTitle"];
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


@end
