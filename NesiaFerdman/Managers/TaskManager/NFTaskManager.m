//
//  NFTaskManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTaskManager.h"

@implementation NFTaskManager

+ (NFTaskManager *)sharedManager {
    static NFTaskManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inputEventsArray = [NSMutableArray array];
        self.inputImportantEventsArray = [NSMutableArray array];
        self.inputConclusionsEventsArray = [NSMutableArray array];
        self.eventTaskDictionary = [NSMutableDictionary dictionary];
        self.eventImportantDictionary = [NSMutableDictionary dictionary];
        self.eventConclusionsDictionary = [NSMutableDictionary dictionary];
        self.valuesArray = [NSMutableArray array];
        self.selectedValuesArray = [NSMutableArray array];
        self.resultCategoryArray = [NSMutableArray array];
        self.resultsArray = [NSMutableArray array];
        self.resultsDictionary = [NSMutableDictionary dictionary];
        self.manifestationsArray = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray*) getAllManifestations {
    return self.manifestationsArray;
}

- (NSMutableArray*)getAllResultCategory {
    return self.resultCategoryArray;
}

- (NSMutableArray *)getAllValues {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NFValue *value in self.valuesArray)
        if (!value.isDeleted) {
            [resultArray addObject:value];
        }
    return resultArray;
}

- (NSMutableArray*)getAllResult {
    return self.resultsArray;
}

- (NSMutableArray*)getResultWithFilter:(NFResultCategory*)resultCategory forDay:(NSDate*)date {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NFResult *result in _resultsArray) {
        if ([result.resultCategoryId isEqualToString:resultCategory.resultCategoryId]) {
            [tempArray addObject:result];
        }
    }
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [self convertToDictionary:resultDic array:tempArray];
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:[resultDic objectForKey:[self stringFromDate:date]]];
    return result;
}

- (NSMutableArray *)getTaskForHour:(NSInteger)hour WithArray:(NSMutableArray *)eventsArray {
    NSMutableArray *result = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.startDate contains[c] %@",[NSString stringWithFormat:@"T%02ld", (long)hour]];
    [result addObjectsFromArray:[eventsArray filteredArrayUsingPredicate:predicate]];
    return [self sortArray:result withKey:@"startDate"];
}

- (NSMutableDictionary*)getAllTaskDictionaryWithFilter {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self convertToDictionary:result array:[self filterArray:_inputEventsArray withFilterArray:_selectedValuesArray]];
    return _selectedValuesArray.count > 0 ? result: _eventTaskDictionary;
}

- (NSMutableDictionary*)getAllTaskDictionaryWithFilterValue:(NFValue*)value{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self convertToDictionary:result array:[self filterArray:_inputEventsArray withFilterArray:@[value]]];
    return result;
}

- (NSMutableArray *)getTasksForDay:(NSDate*)currentDate {
    NSMutableArray *equalsEvent = [NSMutableArray array];
    [equalsEvent addObjectsFromArray:[_eventTaskDictionary objectForKey:[self stringFromDate:currentDate]]];
    
    return _selectedValuesArray.count > 0 ? [self filterArray:equalsEvent withFilterArray:_selectedValuesArray]:equalsEvent;
}

- (NSMutableArray *)getImportantForDay:(NSDate*)currentDate {
    NSMutableArray *equalsEvent = [NSMutableArray array];
    [equalsEvent addObjectsFromArray:[_eventImportantDictionary objectForKey:[self stringFromDate:currentDate]]];
    return equalsEvent;
}

- (NSMutableArray *)getTaskForMonth:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[_eventTaskDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [_eventTaskDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
//    NSMutableArray *tempArray = [NSMutableArray array];
//    [tempArray addObjectsFromArray:resultArray];
    return resultArray.count > 0 ? [self getObjectsFromArrayWithArrays:(NSMutableArray *)resultArray] : nil;
}

- (NSMutableArray*)getTaskForMonth:(NSDate*)currentDate withValue:(NFValue*)value {
    NSMutableDictionary* monthTaskaWithValue = [NSMutableDictionary dictionary];
    [monthTaskaWithValue setDictionary:[self getAllTaskDictionaryWithFilterValue:value]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[monthTaskaWithValue allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [monthTaskaWithValue objectsForKeys:filtered notFoundMarker:[NSNull null]];
    return (NSMutableArray*)resultArray;
}


- (NSMutableArray *)getConclusionsForDay:(NSDate*)currentDate {
    NSMutableArray *equalsEvent = [NSMutableArray array];
    [equalsEvent addObjectsFromArray:[_eventConclusionsDictionary objectForKey:[self stringFromDate:currentDate]]];
    return equalsEvent;
}

- (NSMutableArray *)getConclusionsForMonth:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[_eventConclusionsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [_eventConclusionsDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
    return resultArray.count > 0 ? (NSMutableArray *)resultArray : nil;
}


- (NSMutableArray *)getImportantForMonth:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[_eventImportantDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [_eventImportantDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
    return resultArray.count > 0 ? (NSMutableArray *)resultArray : nil;
}

#pragma mark - Helpers

- (NSMutableArray*)getObjectsFromArrayWithArrays:(NSMutableArray *)inputArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSMutableArray *array in inputArray) {
        if ([array isKindOfClass:[NSMutableArray class]]) {
            [resultArray addObjectsFromArray:array];
        }
    }
    return resultArray;
}

- (NSString *)stringDate:(NSString *)stringInput
              withFormat:(NSString *)inputFormat
      dateStringToFromat:(NSString*)outputFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:stringInput];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:outputFormat];
    NSString* newDate = [dateFormatter1 stringFromDate:dateFromString];
    return newDate;
}

- (NSString *)stringFromDate:(NSDate *)currentDate  {
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString* newDate = [dateFormatter1 stringFromDate:currentDate];
    return newDate;
}

- (void)convertToDictionary:(NSMutableDictionary *)dic array:(NSMutableArray *)array {
    
    if (array.count > 0) {
        for (NFEvent *event in array) {
            NSString *eventKey = [event.startDate substringToIndex:10];
            if(!dic[eventKey]){
                dic[eventKey] = [NSMutableArray new];
            }
            [dic[eventKey] addObject:event];
        }
    }
}

- (void)clearAllData {
    
    [self.inputEventsArray removeAllObjects];
    [self.inputImportantEventsArray removeAllObjects];
    [self.inputConclusionsEventsArray removeAllObjects];
    [self.eventTaskDictionary removeAllObjects];
    [self.eventImportantDictionary removeAllObjects];
    [self.eventConclusionsDictionary removeAllObjects];
    [self.valuesArray removeAllObjects];
    [self.resultCategoryArray removeAllObjects];
}

- (NSMutableArray*)filterArray:(NSArray*)input withFilterArray:(NSArray*)filterArray {
    NSMutableArray *result = [NSMutableArray array];
    for (NFEvent *event in input) {
        for (NFValue *val in filterArray) {
            NSMutableArray *tempArray = [NSMutableArray array];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.valueId contains[c] %@",val.valueId];
            [tempArray addObjectsFromArray:[event.values filteredArrayUsingPredicate:predicate]];
            if (tempArray.count) {
                [result addObject:event];
                break;
            }
        }
    }
    return result;
}

- (NSMutableDictionary *)eventSortedByValue:(NSMutableArray* )inputArray {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayVal = [NSMutableArray array];
    for (NFEvent *event in inputArray) {
        for (NFValue *val in _valuesArray) {
            NSMutableArray *tempArray = [NSMutableArray array];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.valueId contains[c] %@",val.valueId];
            [tempArray addObjectsFromArray:[event.values filteredArrayUsingPredicate:predicate]];
            if (tempArray.count) {
                //[result addObject:tempArray];
                NSString *eventKey = val.valueTitle;
                if(!result[eventKey]){
                    result[eventKey] = [NSMutableArray new];
                }
                [result[eventKey] addObject:event];
            }
        }
        if (event.values.count < 1) {
            [tempArrayVal addObject:event];
        }
    }
    [result setObject:tempArrayVal forKey:@"other"];
    return result;
}

- (void)addAllEventsFromArray:(NSMutableArray *)array {
    [self clearAllData];
    
    NSMutableArray *eventsArray = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.eventType == %d", Event];
    [eventsArray addObjectsFromArray:[array filteredArrayUsingPredicate:predicate]];
    [self.inputEventsArray addObjectsFromArray:eventsArray];
    [self convertToDictionary:_eventTaskDictionary array:_inputEventsArray];
    
    NSMutableArray *eventsImportantArray = [NSMutableArray array];
    NSPredicate *predicateImportan = [NSPredicate predicateWithFormat:@"self.eventType == %d", Important];
    [eventsImportantArray addObjectsFromArray:[array filteredArrayUsingPredicate:predicateImportan]];
    [self.inputImportantEventsArray addObjectsFromArray:eventsImportantArray];
    [self convertToDictionary:_eventImportantDictionary array:_inputImportantEventsArray];
    
    NSMutableArray *eventsConclusions = [NSMutableArray array];
    NSPredicate *predicateConclusions = [NSPredicate predicateWithFormat:@"self.eventType == %d", Conclusions];
    [eventsConclusions addObjectsFromArray:[array filteredArrayUsingPredicate:predicateConclusions]];
    [self.inputConclusionsEventsArray addObjectsFromArray:eventsConclusions];
    [self convertToDictionary:_eventConclusionsDictionary array:_inputConclusionsEventsArray];
    
    [self convertToDictionary:self.resultsDictionary array:self.resultsArray];
}

- (NSMutableArray*)sortArray:(NSMutableArray *)array withKey:(NSString*)key {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return (NSMutableArray*)[array sortedArrayUsingDescriptors:sortDescriptors];
}


@end
