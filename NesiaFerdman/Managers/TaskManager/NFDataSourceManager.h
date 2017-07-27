//
//  NFDataSourceManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFNEvent.h"
#import "NFNValue.h"
#import "NFNRsult.h"
#import "NFNRsultCategory.h"

@interface NFDataSourceManager : NSObject

+ (NFDataSourceManager*)sharedManager;

// Result methods

- (NSMutableArray*)getResultWithFilter:(NFNRsultCategory*)resultCategory forDay:(NSDate*)date;
- (NSMutableArray*)getResultWithFilter:(NFNRsultCategory*)resultCategory forMonth:(NSDate*)date;

// Events methods

- (NSMutableArray *)getEventForDay:(NSDate*)currentDate;
- (NSMutableArray *)getEventForHour:(NSInteger)hour WithArray:(NSMutableArray *)eventsArray;
- (NSMutableDictionary*)getAllEventsDictionaryWithFilter;
- (NSMutableDictionary*)getAllEventsDictionaryWithFilterValue:(NFNValue*)value;
- (NSMutableArray *)getEventsListForMonth:(NSDate*)currentDate;
- (NSMutableDictionary*)getEventsListForMonthWithoutValues:(NSDate*)currentDate;
- (NSMutableArray *)getEventsListForDayWithoutValues:(NSDate*)currentDate;
- (NSMutableArray*)getTaskForMonth:(NSDate*)currentDate withValue:(NFNValue*)value;
- (NSMutableDictionary*)getTaskForMonthDictionary:(NSDate*)currentDate withValue:(NFNValue*)value;
- (NSMutableArray*)getTaskForDay:(NSDate*)currentDate withValue:(NFNValue*)value;

- (void)setEventList:(NSArray*)array;
- (void)setValueList:(NSArray*)array;
- (void)setManifestationList:(NSArray*)array;
- (void)setResultCategoryList:(NSArray*)array;
- (void)setResultList:(NSArray*)array;
- (void)setCalendarList:(NSArray*)array;
- (void)setQuoteList:(NSArray*)array;
- (void)setSelectedValueList:(NSArray*)array;

- (NSArray*)getEventList;
- (NSArray*)getValueList;
- (NSArray*)getManifestationList;
- (NSArray*)getResultCategoryList;
- (NSArray*)getResultList;
- (NSArray*)getCalendarList;
- (NSArray*)getQuoteList;
- (NSArray*)getSelectedValueList;


@end
