//
//  NFMenuElements.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MenuItem)
{
    Statistic,
    Values,
    Settings,
    Training,
    About,
    Exit
};


@interface NFMenuElements : NSObject

@property (strong, nonatomic) NSMutableArray *itemsArray;

+ (void)navigateToScreenWithIndex:(NSInteger)index target:(id)target;

@end
