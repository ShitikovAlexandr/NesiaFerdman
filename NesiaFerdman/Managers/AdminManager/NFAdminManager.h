//
//  NFAdminManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/24/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFNEvent.h"
#import "NFNValue.h"
#import "NFNRsultCategory.h"

@interface NFAdminManager : NSObject



/** write standart list of value to db*/
+ (void)writeAppStandartListOfValueToDataBase;

/** write standart list of result category to db*/
+ (void)writeAppStandartListOfResultCategoryToDataBase;

+ (void)writeStandartManifestationsToDataBase;

@end
