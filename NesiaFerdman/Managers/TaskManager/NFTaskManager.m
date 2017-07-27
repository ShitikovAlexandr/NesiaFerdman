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
        self.calendarList = [NSMutableArray array];
    }
    return self;
}

//***************************
- (void)setEventList:(NSArray*)eventList {
    [_inputEventsArray addObjectsFromArray:eventList];
}

- (void)setValueList:(NSArray*)valueList {
    [_valuesArray removeAllObjects];
    [_valuesArray addObjectsFromArray:valueList];
}

- (void)setResultCategoryList:(NSArray*)resultCategoreList {
    [_resultCategoryArray removeAllObjects];
    [_resultCategoryArray addObjectsFromArray:resultCategoreList];
}

- (void)setManifestationList:(NSArray*)manifestationList {
    [_manifestationsArray removeAllObjects];
    [_manifestationsArray addObjectsFromArray:manifestationList];
}

- (void)setResultList:(NSArray*)resultList {
    [_resultsArray removeAllObjects];
    [_resultsArray addObjectsFromArray:resultList];
}

- (void)setCalendarList:(NSArray*)calendarList {
    [_calendarArray addObjectsFromArray:calendarList];
}


//***************************

- (NSMutableArray*) getAllManifestations {
    return self.manifestationsArray;
}

- (NSMutableArray*)getAllResultCategory {
    return self.resultCategoryArray;
}

- (NSMutableArray *)getAllValues {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NFNValue *value in self.valuesArray)
        if (!value.isDeleted) {
            [resultArray addObject:value];
        }
    return resultArray;
}

- (NSMutableArray*)getAllResult {
    return self.resultsArray;
}

- (NSMutableArray*)getResultWithFilter:(NFNRsultCategory*)resultCategory forDay:(NSDate*)date {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NFNRsult *result in _resultsArray) {
        if ([result.parentId isEqualToString:resultCategory.idField]) {
            [tempArray addObject:result];
        }
    }
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [self convertResultToDictionary:resultDic array:tempArray]; // change
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:[resultDic objectForKey:[self stringFromDate:date]]];
    return result;
}

- (NSMutableArray*)getResultWithFilter:(NFNRsultCategory*)resultCategory forMonth:(NSDate*)date {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NFNRsult *result in _resultsArray) {
        if ([result.parentId isEqualToString:resultCategory.idField]) {
            [tempArray addObject:result];
        }
    }
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [self convertResultToDictionary:resultDic array:tempArray]; // change
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:date]  substringToIndex:7]];
    NSArray *filtered = [[[resultDic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [resultDic objectsForKeys:filtered notFoundMarker:[NSNull null]];
    return (NSMutableArray*)resultArray;
    return nil;
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

- (NSMutableDictionary*)getAllTaskDictionaryWithFilterValue:(NFNValue*)value{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self convertToDictionary:result array:[self filterArray:_inputEventsArray withFilterArray:@[value]]];
    return result;
}

- (NSMutableArray *)getTasksForDay:(NSDate*)currentDate {
    NSMutableArray *equalsEvent = [NSMutableArray array];
    [equalsEvent addObjectsFromArray:[_eventTaskDictionary objectForKey:[self stringFromDate:currentDate]]];
    return _selectedValuesArray.count > 0 ? [self filterArray:equalsEvent withFilterArray:_selectedValuesArray]:equalsEvent;
}

//- (NSMutableArray *)getImportantForDay:(NSDate*)currentDate {
//    NSMutableArray *equalsEvent = [NSMutableArray array];
//    [equalsEvent addObjectsFromArray:[_eventImportantDictionary objectForKey:[self stringFromDate:currentDate]]];
//    return equalsEvent;
//}

- (NSMutableArray *)getTaskForMonth:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[_eventTaskDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [_eventTaskDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
    return resultArray.count > 0 ? [self getObjectsFromArrayWithArrays:(NSMutableArray *)resultArray] : nil;
}

- (NSMutableDictionary*)getTaskForMonthWithoutValues:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[_eventTaskDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSString *key in filtered) {
        NSMutableArray *tempDayArray = [NSMutableArray array];
        [tempDayArray addObjectsFromArray:[_eventTaskDictionary objectForKey:key]];
        for (NFNEvent *event in [_eventTaskDictionary objectForKey:key]) {
            if (event.values) {
                [tempDayArray removeObject:event];
            }
        }
        if (tempDayArray.count > 0) {
            [resultDic setObject:tempDayArray forKey:key];
        }
    }
    return resultDic;
}

- (NSMutableArray *)getTaskForDayWithoutValues:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:10]];
    NSArray *filtered = [[[_eventTaskDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [_eventTaskDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *tempDay;
    
    for (NSMutableArray *dayArray in resultArray) {
        //[tempDay removeAllObjects];
        tempDay = [NSMutableArray arrayWithArray:dayArray];
        
        for (NFNEvent* event in dayArray) {
            if(event.values) {
                [tempDay removeObject:event];
            }
        }
        if (tempDay.count > 0) {
            [tempArray addObject:tempDay];
        } else {
            NSLog(@"no events");
        }
    }
    return tempArray;
}

- (NSMutableArray*)getTaskForMonth:(NSDate*)currentDate withValue:(NFNValue*)value {
    NSMutableDictionary* monthTaskaWithValue = [NSMutableDictionary dictionary];
    [monthTaskaWithValue setDictionary:[self getAllTaskDictionaryWithFilterValue:value]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[monthTaskaWithValue allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [monthTaskaWithValue objectsForKeys:filtered notFoundMarker:[NSNull null]];
    return (NSMutableArray*)resultArray;
}

- (NSMutableDictionary*)getTaskForMonthDictionary:(NSDate*)currentDate withValue:(NFNValue*)value {
    NSMutableDictionary* monthTaskaWithValue = [NSMutableDictionary dictionary];
    [monthTaskaWithValue setDictionary:[self getAllTaskDictionaryWithFilterValue:value]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[monthTaskaWithValue allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    //NSArray *resultArray = [monthTaskaWithValue objectsForKeys:filtered notFoundMarker:[NSNull null]];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSString *key in filtered) {
        [resultDic setValue:[monthTaskaWithValue objectForKey:key] forKey:key];
    }
    return resultDic;
}

- (NSMutableArray*)getTaskForDay:(NSDate*)currentDate withValue:(NFNValue*)value {
    NSMutableDictionary* monthTaskaWithValue = [NSMutableDictionary dictionary];
    [monthTaskaWithValue setDictionary:[self getAllTaskDictionaryWithFilterValue:value]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:10]];
    NSArray *filtered = [[[monthTaskaWithValue allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [monthTaskaWithValue objectsForKeys:filtered notFoundMarker:[NSNull null]];
    return (NSMutableArray*)resultArray;
}

//- (NSMutableArray *)getConclusionsForDay:(NSDate*)currentDate {
//    NSMutableArray *equalsEvent = [NSMutableArray array];
//    [equalsEvent addObjectsFromArray:[_eventConclusionsDictionary objectForKey:[self stringFromDate:currentDate]]];
//    return equalsEvent;
//}
//
//- (NSMutableArray *)getConclusionsForMonth:(NSDate*)currentDate {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
//    NSArray *filtered = [[[_eventConclusionsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
//    NSArray *resultArray = [_eventConclusionsDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
//    return resultArray.count > 0 ? (NSMutableArray *)resultArray : nil;
//}
//
//- (NSMutableArray *)getImportantForMonth:(NSDate*)currentDate {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
//    NSArray *filtered = [[[_eventImportantDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
//    NSArray *resultArray = [_eventImportantDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
//    return resultArray.count > 0 ? (NSMutableArray *)resultArray : nil;
//}

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
    
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:stringInput];
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:outputFormat];
    NSString* newDate = [dateFormatter1 stringFromDate:dateFromString];
    return newDate;
}

- (NSString *)stringFromDate:(NSDate *)currentDate  {
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString* newDate = [dateFormatter1 stringFromDate:currentDate];
    return newDate;
}

- (void)convertToDictionary:(NSMutableDictionary *)dic array:(NSMutableArray *)array {
    if (array.count > 0) {
        for (NFNEvent *event in array) {
            NSDate *start = [self datefromString:event.startDate];
            NSDate *end = [self datefromString:event.endDate];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            if (![calendar isDate:[self dateWithNoTime:start] inSameDayAsDate:[self dateWithNoTime:end]]) {
                NSLog(@"is repeat event %@ - %@", event.startDate, event.endDate);
                NSLog(@"list of repeat date %@", [self getListOfDateWithStart:start end:end]);
                for (NSDate *date in [self getListOfDateWithStart:start end:end]) {
                    NSString *eventKey = [self stringFromDate:date];
                    if(!dic[eventKey]){
                        dic[eventKey] = [NSMutableArray new];
                    }
                    [dic[eventKey] addObject:event];
                }
            } else {
                NSString *eventKey = [event.startDate substringToIndex:10];
                if(!dic[eventKey]){
                    dic[eventKey] = [NSMutableArray new];
                }
                [dic[eventKey] addObject:event];
            }
        }
    }
}

- (NSDate*)datefromString:(NSString*)dateString {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:16]];
    return dateFromString;
}

- (void)convertResultToDictionary:(NSMutableDictionary *)dic array:(NSMutableArray *)array {
    if (array.count > 0) {
        for (NFNRsult *event in array) {
            NSString *eventKey = [event.createDate substringToIndex:10];
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
    for (NFNEvent *event in input) {
        for (NFNValue *val in filterArray) {
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
    for (NFNEvent *event in inputArray) {
        for (NFNValue *val in _valuesArray) {
            NSMutableArray *tempArray = [NSMutableArray array];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.valueId contains[c] %@",val.valueId];
            [tempArray addObjectsFromArray:[event.values filteredArrayUsingPredicate:predicate]];
            if (tempArray.count) {
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

- (NSMutableArray*)getListOfDateWithStart:(NSDate*)start end:(NSDate*)end {
    NSMutableArray *result = [NSMutableArray new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:start
                                                 toDate:end
                                                options:0];
    NSInteger numberOfDays = components.day;
    
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    [result addObject:start];
    
    for (int i = 1; i <= numberOfDays; i++) {
        [offset setDay:i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:start options:0];
        [result addObject:nextDay];
    }
    if (result.count == 1) {
        NSLog(@"result");
    }
    return result;
}

- (void)addAllEventsFromArray:(NSMutableArray *)array {
    [self clearAllData];
    
    NSMutableArray *eventsArray = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.eventType == %d", Event];
    [eventsArray addObjectsFromArray:[array filteredArrayUsingPredicate:predicate]];
    [self.inputEventsArray addObjectsFromArray:eventsArray];
    [self convertToDictionary:_eventTaskDictionary array:_inputEventsArray];
    
//    NSMutableArray *eventsImportantArray = [NSMutableArray array];
//    NSPredicate *predicateImportan = [NSPredicate predicateWithFormat:@"self.eventType == %d", Important];
//    [eventsImportantArray addObjectsFromArray:[array filteredArrayUsingPredicate:predicateImportan]];
//    [self.inputImportantEventsArray addObjectsFromArray:eventsImportantArray];
//    [self convertToDictionary:_eventImportantDictionary array:_inputImportantEventsArray];
//    
//    NSMutableArray *eventsConclusions = [NSMutableArray array];
//    NSPredicate *predicateConclusions = [NSPredicate predicateWithFormat:@"self.eventType == %d", Conclusions];
//    [eventsConclusions addObjectsFromArray:[array filteredArrayUsingPredicate:predicateConclusions]];
//    [self.inputConclusionsEventsArray addObjectsFromArray:eventsConclusions];
//    [self convertToDictionary:_eventConclusionsDictionary array:_inputConclusionsEventsArray];
    
    [self convertResultToDictionary:self.resultsDictionary array:self.resultsArray]; // change
}

- (NSMutableArray*)sortArray:(NSMutableArray *)array withKey:(NSString*)key {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return (NSMutableArray*)[array sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSDate*) dateWithNoTime:(NSDate*)date {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

@end
