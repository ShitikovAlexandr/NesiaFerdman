//
//  NFValue.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValue.h"
#import <objc/runtime.h>


@implementation NFValue

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *newID = [[NSUUID UUID] UUIDString];
        self.valueId = newID;
    }
    return self;
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        self.valueTitle = [dictionary objectForKey:@"valueTitle"];
        self.valueId = [dictionary objectForKey:@"valueId"];
        self.valueIndex = [dictionary objectForKey:@"valueIndex"];
        self.valueImage = [dictionary objectForKey:@"valueImage"];
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
