//
//  NFTaskManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFYearTask.h"
#import "NFMonthTask.h"
#import "NFWeekTask.h"
#import "NFDayTask.h"
#import "NFHourTask.h"
#import "NFEvent.h"
#import "NFResult.h"
#import "NFResultCategory.h"

@interface NFTaskManager : NSObject
@property (strong, nonatomic) NSMutableArray *inputEventsArray;
@property (strong, nonatomic) NSMutableArray *inputImportantEventsArray;
@property (strong, nonatomic) NSMutableArray *inputConclusionsEventsArray;

@property (strong, nonatomic) NSMutableDictionary *eventTaskDictionary;
@property (strong, nonatomic) NSMutableDictionary *eventImportantDictionary;
@property (strong, nonatomic) NSMutableDictionary *eventConclusionsDictionary;

@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NSMutableArray *selectedValuesArray;

@property (strong, nonatomic) NSMutableArray *resultCategoryArray;
@property (strong, nonatomic) NSMutableArray *manifestationsArray;

@property (strong, nonatomic) NSMutableArray *resultsArray;
@property (strong, nonatomic) NSMutableDictionary *resultsDictionary;

@property (strong, nonatomic) NFYearTask *yearTask;

+ (NFTaskManager *)sharedManager;

- (NSMutableArray *)getTaskForHour:(NSInteger)hour WithArray:(NSMutableArray *)eventsArray;
- (NSMutableArray *)getTasksForDay:(NSDate*)currentDate;
- (NSMutableArray *)getTaskForMonth:(NSDate*)currentDate;
- (NSMutableDictionary*)getAllTaskDictionaryWithFilter;
- (NSMutableArray*)getTaskForMonth:(NSDate*)currentDate withValue:(NFValue*)value;
- (NSMutableArray *)getTaskForMonthWithoutValues:(NSDate*)currentDate;

- (NSMutableArray *)getImportantForDay:(NSDate*)currentDate;
- (NSMutableArray *)getImportantForMonth:(NSDate*)currentDate;

- (NSMutableArray *)getConclusionsForDay:(NSDate*)currentDate;
- (NSMutableArray *)getConclusionsForMonth:(NSDate*)currentDate;
- (NSMutableDictionary *)eventSortedByValue:(NSMutableArray* )inputArray;

- (NSMutableArray *)getAllValues;
- (NSMutableArray*) getAllManifestations;

- (NSMutableArray*)getAllResultCategory;
- (NSMutableArray*)getAllResult;
- (NSMutableArray*)getResultWithFilter:(NFResultCategory*)resultCategory forDay:(NSDate*)date;
- (NSMutableArray*)getResultWithFilter:(NFResultCategory*)resultCategory forMonth:(NSDate*)date;

- (void)clearAllData;
- (void)addAllEventsFromArray:(NSMutableArray *)array;

- (void)convertToDictionary:(NSMutableDictionary *)dic array:(NSMutableArray *)array;

@end
