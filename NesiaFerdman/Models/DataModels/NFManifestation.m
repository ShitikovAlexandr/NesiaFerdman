//
//  NFManifestation.m
//  NesiaFerdman
//
//  Created by alex on 25.06.17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFManifestation.h"
#import <objc/runtime.h>

@implementation NFManifestation

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.manifestationId = [dictionary objectForKey:@"manifestationId"];
        self.index = [dictionary objectForKey:@"index"];
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
        self.manifestationId = newID;
    }
    return self;
}

@end
