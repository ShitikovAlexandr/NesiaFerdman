//
//  NFSettingItem.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFSettingItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL isON;
@property (assign, nonatomic) NSInteger index;

@end
