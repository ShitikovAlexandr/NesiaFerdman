//
//  NFEditResultController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFEditResultController.h"
#import "NFViewWithDownBorder.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFActivityIndicatorView.h"
#import <UITextView+Placeholder.h>
#import "NFSyncManager.h"
#import "NotifyList.h"
#import "NFTextView.h"
#import "NFDatePicker.h"

@interface NFEditResultController ()
@property (weak, nonatomic) IBOutlet NFViewWithDownBorder *mainView;
@property (weak, nonatomic) IBOutlet NFTextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;
@property (strong, nonatomic) NFDatePicker *datePickerStart;

@end

@implementation NFEditResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStartDataToDisplay];
    [self.textView becomeFirstResponder];
    _mainView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStylePlain target:self action:@selector(saveChanges)];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    [self.textView validateWithTarget:self placeholderText:@"Описание" min:1 max:300];
    _datePickerStart = [[NFDatePicker alloc] initWithTextField:_dateTextField];
    _datePickerStart.onlyDate = true;
    _datePickerStart.datePickerMode = UIDatePickerModeDate;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endUpdate) name:END_UPDATE_DATA object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA object:nil];
}

#pragma mark - Helpers

- (void)setStartDataToDisplay {
    self.dateTitleLabel.text = @"Дата";
    self.textView.placeholder = @"Описание";
    if (_resultItem) {
        self.textView.text = self.resultItem.resultDescription;
        self.title = self.category.resultCategoryTitle;
        self.dateTextField.text = [self stringDate:_resultItem.startDate withFormat:@"yyyy-MM-dd'T'HH:mm:ss" dateStringToFromat:@"LLLL, dd, yyyy"];
    } else {
        self.title = @"Создание";
        self.dateTextField.text = [self stringFromDate:_selectedDate];
    }
}

- (void)saveChanges {
    if ([_textView isValidString]) {
        
        _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
        [_indicator startAnimating];
        if (!_resultItem) {
            _resultItem = [[NFResult alloc]  init];
            _resultItem.resultCategoryId = _category.resultCategoryId;
        }
        _resultItem.startDate = [self stringDate:_dateTextField.text withFormat:@"LLLL, dd, yyyy" dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
        _resultItem.resultDescription = self.textView.text;
        [[NFSyncManager sharedManager] writeResultToFirebase:_resultItem];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NFSyncManager sharedManager]  updateAllData];
        });
    }
}

- (void)endUpdate {
    [_indicator endAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (NSString*)convertStringDateToStringCurrentFormat:(NSString*)inputString {
//    NSDate *newDate = [self dateFromString:inputString];
//    NFDateFormatter *dateFormater = [NFDateFormatter new];
//    [dateFormater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//    return [dateFormater stringFromDate:newDate];
//}

- (NSString *)stringFromDate:(NSDate *)date {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy"];
    return [dateFormater stringFromDate:date];
}

- (NSDate*)dateFromString:(NSString*)stringDate {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy"];
    
    return [dateFormater dateFromString:[stringDate substringToIndex:7]];
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




@end
