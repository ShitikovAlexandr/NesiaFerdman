//
//  NFDataSourceManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDataSourceManager.h"
#import "NFGoogleCalendar.h"


@interface NFDataSourceManager ()

@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NSMutableArray *manifestationArray;
@property (strong, nonatomic) NSMutableArray *resultCategoryArray;
@property (strong, nonatomic) NSMutableArray *resultArray;
@property (strong ,nonatomic) NSMutableArray *calendarArray;
@property (strong, nonatomic) NSMutableArray *quoteArray;

@property (strong, nonatomic) NSMutableArray *selectedValuesArray;
@property (strong, nonatomic) NSMutableDictionary *eventsDictionary;
@property (strong, nonatomic) NSMutableDictionary *resultDictionary;

@end

@implementation NFDataSourceManager

+ (NFDataSourceManager*)sharedManager {
    static NFDataSourceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)reset {
    _eventsArray = [NSMutableArray new];
    _valuesArray = [NSMutableArray new];
    _manifestationArray = [NSMutableArray new];
    _resultCategoryArray = [NSMutableArray new];
    _resultArray = [NSMutableArray new];
    _calendarArray = [NSMutableArray new];
    _quoteArray = [NSMutableArray new];
    
    _selectedValuesArray = [NSMutableArray new];
    _eventsDictionary = [NSMutableDictionary new];
    _resultDictionary = [NSMutableDictionary new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _eventsArray = [NSMutableArray new];
        _valuesArray = [NSMutableArray new];
        _manifestationArray = [NSMutableArray new];
        _resultCategoryArray = [NSMutableArray new];
        _resultArray = [NSMutableArray new];
        _calendarArray = [NSMutableArray new];
        _quoteArray = [NSMutableArray new];
        
        _selectedValuesArray = [NSMutableArray new];
        _eventsDictionary = [NSMutableDictionary new];
        _resultDictionary = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - data source methods

// Result methods

- (NSMutableArray*)getResultWithFilter:(NFNRsultCategory*)resultCategory forDay:(NSDate*)date {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NFNRsult *result in _resultArray) {
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
    for (NFNRsult *result in _resultArray) {
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
}

// Events methods

- (NSMutableDictionary *)eventSortedByValue:(NSMutableArray* )inputArray {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayVal = [NSMutableArray array];
    for (NFNEvent *event in inputArray) {
        if (!event.isDeleted) {
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
    }
    [result setObject:tempArrayVal forKey:@"other"];
    return result;
}


- (NSMutableArray *)getEventForDay:(NSDate*)currentDate {
    NSMutableArray *equalsEvent = [NSMutableArray array];
    [equalsEvent addObjectsFromArray:[_eventsDictionary objectForKey:[self stringFromDate:currentDate]]];
    return _selectedValuesArray.count > 0 ? [self filterArray:equalsEvent withFilterArray:_selectedValuesArray]:equalsEvent;
}

- (NSMutableArray *)getEventForHour:(NSInteger)hour WithArray:(NSMutableArray *)eventsArray {
    NSMutableArray *result = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.startDate contains[c] %@",[NSString stringWithFormat:@"T%02ld", (long)hour]];
    [result addObjectsFromArray:[eventsArray filteredArrayUsingPredicate:predicate]];
    return [self sortArray:result withKey:@"startDate"];
}

- (NSMutableDictionary*)getAllEventsDictionaryWithFilter {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self convertEventsListToDictionary:result array:[self filterArray:_eventsArray withFilterArray:_selectedValuesArray]];
    return _selectedValuesArray.count > 0 ? result: _eventsDictionary;
}

- (NSMutableDictionary*)getAllEventsDictionaryWithFilterValue:(NFNValue*)value {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self convertEventsListToDictionary:result array:[self filterArray:_eventsArray withFilterArray:@[value]]];
    return result;
}

- (NSMutableArray *)getEventsListForMonth:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[_eventsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [_eventsDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
    return resultArray.count > 0 ? [self getObjectsFromArrayWithArrays:(NSMutableArray *)resultArray] : nil;
}

- (NSMutableDictionary*)getEventsListForMonthWithoutValues:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:7]];
    NSArray *filtered = [[[_eventsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSString *key in filtered) {
        NSMutableArray *tempDayArray = [NSMutableArray array];
        [tempDayArray addObjectsFromArray:[_eventsDictionary objectForKey:key]];
        for (NFNEvent *event in [_eventsDictionary objectForKey:key]) {
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

- (NSMutableArray *)getEventsListForDayWithoutValues:(NSDate*)currentDate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:10]];
    NSArray *filtered = [[[_eventsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [_eventsDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *tempDay;
    for (NSMutableArray *dayArray in resultArray) {
        tempDay = [NSMutableArray arrayWithArray:dayArray];
        for (NFNEvent* event in dayArray) {
            if(event.values) {
                [tempDay removeObject:event];
            }
        }
        if (tempDay.count > 0) {
            [tempArray addObject:tempDay];
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
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSString *key in filtered) {
        [resultDic setValue:[monthTaskaWithValue objectForKey:key] forKey:key];
    }
    return resultDic;
}

- (NSMutableArray*)getTaskForDay:(NSDate*)currentDate withValue:(NFNValue*)value {
//    NSMutableDictionary* monthTaskaWithValue = [NSMutableDictionary dictionary];
//    [monthTaskaWithValue setDictionary:[self getAllTaskDictionaryWithFilterValue:value]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:currentDate]  substringToIndex:10]];
//    NSArray *filtered = [[[monthTaskaWithValue allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
//    NSArray *resultArray = [monthTaskaWithValue objectsForKeys:filtered notFoundMarker:[NSNull null]];
    
    return [self getEventforDay:currentDate withValue:value];//(NSMutableArray*)resultArray;
}


// test method
- (NSMutableArray*)getEventforDay:(NSDate*)date withValue:(NFNValue*)value {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", [[self stringFromDate:date]  substringToIndex:10]];
    NSArray *filtered = [[[_eventsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] filteredArrayUsingPredicate:predicate];
    NSArray *resultArray = [_eventsDictionary objectsForKeys:filtered notFoundMarker:[NSNull null]];
    NSMutableArray *resultWithValue = [NSMutableArray array];
    for (NSArray  *dayArray in resultArray) {
        NSMutableArray *dayTempArray = [NSMutableArray array];
        for (NFNEvent *event in dayArray) {
            for (NFNValue *val in event.values) {
                if ([val.valueId isEqualToString:value.valueId]) {
                    [dayTempArray addObject:event];
                    break;
                }
            }
        }
        if (dayTempArray.count > 0) {
            [resultWithValue addObject:dayTempArray];
        }
    }
    return resultWithValue;
}

//*****************

- (NSString*)getHexColorWithGoogleCalendarId:(NSString*)calendarId {
    for (NFGoogleCalendar *calendar in _calendarArray) {
        if ([calendarId isEqualToString:calendar.idField]) {
            return calendar.backgroundColor;
            break;
        }
    }
    return nil;
}

#pragma mark - get/set list methods

- (void)setEventList:(NSArray*)array {
    [_eventsArray removeAllObjects];
    [_eventsArray addObjectsFromArray:array];
    [self setEventDictionaryList];
}

- (void)setValueList:(NSArray*)array {
    [_valuesArray removeAllObjects];
    [_valuesArray addObjectsFromArray:array];
}

- (void)setManifestationList:(NSArray*)array {
    [_manifestationArray removeAllObjects];
    [_manifestationArray addObjectsFromArray:array];
}

- (void)setResultCategoryList:(NSArray*)array {
    [_resultCategoryArray removeAllObjects];
    [_resultCategoryArray addObjectsFromArray:array];
}

- (void)setResultList:(NSArray*)array {
    [_resultArray removeAllObjects];
    [_resultArray addObjectsFromArray:array];
    [self setResultdictionaryList];
}

- (void)setCalendarList:(NSArray*)array {
    [_calendarArray removeAllObjects];
    [_calendarArray addObjectsFromArray:array];
}

- (void)setQuoteList:(NSArray*)array {
    [_quoteArray removeAllObjects];
    [_quoteArray addObjectsFromArray:array];
}

- (void)setSelectedValueList:(NSArray*)array {
    [_selectedValuesArray removeAllObjects];
    [_selectedValuesArray addObjectsFromArray:array];
}

- (void)setEventDictionaryList {
    [_eventsDictionary removeAllObjects];
    [self convertEventsListToDictionary:_eventsDictionary array:_eventsArray];
}

- (void)setResultdictionaryList {
    [_resultDictionary removeAllObjects];
    
    if (_resultArray.count > 0) {
        for (NFNRsult *event in _resultArray) {
            if (event.createDate != nil) {
            NSString *eventKey = [event.createDate substringToIndex:10];
            if(!_resultDictionary[eventKey]){
                _resultDictionary[eventKey] = [NSMutableArray new];
            }
            [_resultDictionary[eventKey] addObject:event];
        }
        }
    }
}

- (NSArray*)getEventList {
    return _eventsArray;
}

- (NSArray*)getValueList {
    NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"!SELF.isDeleted == YES"];
    NSArray *items = [_valuesArray filteredArrayUsingPredicate:deletePredicate];
    return [self sortArray:(NSMutableArray*)items withKey:@"valueIndex"];
}

- (NSArray*)getManifestationListWithValue:(NFNValue*)value {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.parentId CONTAINS[c]%@",value.valueId];
    return [_manifestationArray filteredArrayUsingPredicate:predicate];
}

- (NSArray*)getManifestationList {
    return _manifestationArray;
}

- (NSArray*)getResultCategoryList {
    return _resultCategoryArray;
}

- (NSArray*)getResultList {
    return _resultArray;
}

- (NSArray*)getCalendarList {
    return _calendarArray;
}

- (NSArray*)getQuoteList {
    return _quoteArray;
}

- (NSArray*)getSelectedValueList {
    return _selectedValuesArray;
}

- (void)resetSelectedValueList {
    [_selectedValuesArray removeAllObjects];
}

- (void)addValuesToSelectedList:(NSArray*)array {
    [_selectedValuesArray addObjectsFromArray:array];
}

//*********************************

- (void)addEventToDataSource:(NFNEvent*)event {
    [_eventsArray addObject:event];
}

- (void)addValueToDataSource:(NFNValue*)value {
    [_valuesArray addObject:value];
}

- (void)addManifestationToDataSource:(NFNManifestation*)manifestation {
    [_manifestationArray addObject:manifestation];
}

- (void)addResultToDataSource:(NFNRsult*)result {
    [_resultArray addObject:result];
}

- (void)removeEventFromDataSource:(NFNEvent*)event {
    [_eventsArray removeObject:event];
}

- (void)removeValueFromDataSource:(NFNValue*)value {
    [_valuesArray removeObject:value];
}

- (void)removeManifestationFromDataSource:(NFNManifestation*)manifestation {
    [_manifestationArray removeObject:manifestation];
}
- (void)removeResultFromDataSource:(NFNRsult*)result {
    [_resultArray removeObject:result];
}

#pragma mark - Helpers

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

- (NSDate*)datefromString:(NSString*)dateString {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    if (dateString.length >=16) {
        NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:16]];
        return dateFromString;
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [dateFormatter dateFromString:[dateString substringToIndex:10]];
        return dateFromString;
    }
}

- (NSDate*) dateWithNoTime:(NSDate*)date {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

- (NSString *)stringFromDate:(NSDate *)currentDate  {
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString* newDate = [dateFormatter1 stringFromDate:currentDate];
    return newDate;
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

- (NSMutableArray*)sortArray:(NSMutableArray *)array withKey:(NSString*)key {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return (NSMutableArray*)[array sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)convertEventsListToDictionary:(NSMutableDictionary *)dic array:(NSMutableArray *)array {
    if (array.count > 0) {
        for (NFNEvent *event in array) {
            if (!event.isDeleted) {
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
        }//
    }
}

- (void)convertResultToDictionary:(NSMutableDictionary *)dic array:(NSMutableArray *)array {
    if (array.count > 0) {
        for (NFNRsult *event in array) {
            if (event.createDate != nil) {
            NSString *eventKey = [event.createDate substringToIndex:10];
            if(!dic[eventKey]){
                dic[eventKey] = [NSMutableArray new];
            }
            [dic[eventKey] addObject:event];
        }
        }
    }
}

- (NSMutableArray*)getObjectsFromArrayWithArrays:(NSMutableArray *)inputArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSMutableArray *array in inputArray) {
        if ([array isKindOfClass:[NSMutableArray class]]) {
            [resultArray addObjectsFromArray:array];
        }
    }
    return resultArray;
}

- (NSMutableDictionary*)getAllTaskDictionaryWithFilterValue:(NFNValue*)value{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self convertEventsListToDictionary:result array:[self filterArray:_eventsArray withFilterArray:@[value]]];
    return result;
}



@end
