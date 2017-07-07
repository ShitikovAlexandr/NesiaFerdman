//
//  NFValue.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValue.h"
#import <objc/runtime.h>

@interface NFValue() <NSCopying>

@end


@implementation NFValue

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *newID = [[NSUUID UUID] UUIDString];
        self.valueId = newID;
        self.valueImage = @"defaultValue.png";
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        self.valueTitle = [dictionary objectForKey:@"valueTitle"];
        self.valueId = [dictionary objectForKey:@"valueId"];
        self.valueIndex = [dictionary objectForKey:@"valueIndex"];
        self.valueImage = [dictionary objectForKey:@"valueImage"] ? [dictionary objectForKey:@"valueImage"] : @"defaultValue.png";
        self.isDeleted = [[dictionary objectForKey:@"isDeleted"] boolValue];
        self.manifestations = [NSMutableArray array];
        if ([dictionary objectForKey:@"manifestations"]) {
            NSMutableArray *dicArray = [NSMutableArray array];
            [dicArray addObjectsFromArray:[[dictionary objectForKey:@"manifestations"] allValues]];
            for (NSDictionary *dic in dicArray) {
                NFManifestation *item = [[NFManifestation alloc] initWithDictionary:dic];
                [self.manifestations addObject:item];
            }
        }
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
        if ([value isKindOfClass:[NSArray class]]) {
            //NSLog(@"array %@", value);
        }
        else if (value) {
            [dictionary setObject:value forKey:key];
        }
    }
    free(properties);
    return dictionary;
}

- (id) copyWithZone:(NSZone *)zone {
    NFValue *copyValue = [[NFValue allocWithZone:zone] init];
    [copyValue setValueTitle:self.valueTitle];
    [copyValue setValueId:self.valueId];
    [copyValue setValueIndex:self.valueIndex];
    [copyValue setValueImage:self.valueImage];
    [copyValue setIsDeleted:self.isDeleted];
    [copyValue setManifestations:[NSMutableArray arrayWithArray:self.manifestations]];
    return copyValue;
}


@end
