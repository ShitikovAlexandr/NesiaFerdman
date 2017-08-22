//
//  NFPeriodFilterView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFPeriodFilterView.h"
#import "NFStyleKit.h"
#import "NFDatePicker.h"
#import "NFTaskManager.h"
#import "NotifyList.h"

@interface NFPeriodFilterView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (strong, nonatomic) NFDatePicker *startPicker;
@property (strong, nonatomic) NFDatePicker *endPicker;
@end

@implementation NFPeriodFilterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _selectedDatePeriodArray = [NSMutableArray array];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    subview.frame = self.bounds;
    subview.backgroundColor = [NFStyleKit _lightGrey];
    [self addSubview:subview];
    _startDateTextField.delegate = self;
    _endDateTextField.delegate = self;
    
    _startDateTextField.backgroundColor = [NFStyleKit _base_GREY];
    _startDateTextField.layer.borderColor = [NFStyleKit _borderDarkGrey].CGColor;
    _startDateTextField.layer.borderWidth = 1.f;
    _startDateTextField.layer.cornerRadius = 6.f;

    _endDateTextField.backgroundColor = [NFStyleKit _base_GREY];
    _endDateTextField.layer.borderColor = [NFStyleKit _borderDarkGrey].CGColor;
    _endDateTextField.layer.borderWidth = 1.f;
    _endDateTextField.layer.cornerRadius = 6.f;
    
    _startPicker = [[NFDatePicker alloc] initWithTextField:_startDateTextField];
    _startPicker.onlyDate = true;
    _startPicker.datePickerMode = UIDatePickerModeDate;
    _startPicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:[self setPeriodMonth:-24]];
    _startPicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:[self setPeriodMonth:24]];
    
    _endPicker = [[NFDatePicker alloc] initWithTextField:_endDateTextField];
    _endPicker.onlyDate = true;
    _endPicker.datePickerMode = UIDatePickerModeDate;
    _endPicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:[self setPeriodMonth:-24]];
    _endPicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:[self setPeriodMonth:24]];
    
    //set start date to textfields
    _startDateTextField.text = [_startPicker stringFromDateOnly:[NSDate date]];
    _endDateTextField.text = [_startPicker stringFromDateOnly:[NSDate date]];
    [_selectedDatePeriodArray addObject:_startPicker.date];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSDate *start = [self dateFromString:_startDateTextField.text];
    NSDate *end = [self dateFromString:_endDateTextField.text];
    if([end compare:start] == NSOrderedAscending) {
        [NFPop startAlertWithMassage:kWrongDatesPerion];
        _endDateTextField.text = _startDateTextField.text;
        _endPicker.date = _startPicker.date;
    }
    [self addNewRangeOfDateToArrayFrom:start to:end];
    NSNotification *notification = [NSNotification notificationWithName:HEADER_RANDOM_PERIOD object:self];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}

- (void)addNewRangeOfDateToArrayFrom:(NSDate*)start to:(NSDate*)end {
    [_selectedDatePeriodArray removeAllObjects];
    [_selectedDatePeriodArray addObjectsFromArray:[[NFTaskManager sharedManager] getListOfDateWithStart:start end:end]];
    NSLog(@"range of date array %@", _selectedDatePeriodArray);
}

#pragma mark - Helpers

- (NSDate*)dateFromString:(NSString*)stringDate {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"dd MMMM yyyy"];
    return [dateFormater dateFromString:stringDate];
}

- (NSInteger)setPeriodMonth:(NSInteger)month {
    return 2678400 * month;
}

@end
