//
//  NFEditResultController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFEditResultController.h"
#import "NFViewWithDownBorder.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFActivityIndicatorView.h"
#import <UITextView+Placeholder.h>
#import "NFNSyncManager.h"
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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endUpdate) name:END_UPDATE_DATA object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA object:nil];
}

#pragma mark - Helpers

- (void)setStartDataToDisplay {
    [_deleteButton setTitle:@"Удалить" forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    self.dateTitleLabel.text = @"Дата";
    self.textView.placeholder = @"Описание";
    if (_resultItem) {
        self.deleteButton.hidden = false;
        self.textView.text = self.resultItem.title;
        self.title = self.category.title;
        self.dateTextField.text = [self stringDate:_resultItem.createDate withFormat:@"yyyy-MM-dd'T'HH:mm:ss" dateStringToFromat:@"dd MMMM yyyy"];
    } else {
        self.deleteButton.hidden = true;
        self.title = @"Создание";
        self.dateTextField.text = [self stringFromDate:_selectedDate];
    }
}

- (void)saveChanges {
    if ([_textView isValidString]) {
        BOOL isNew = false;
        
//        _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
//        [_indicator startAnimating];
        if (!_resultItem) {
            isNew = true;
            _resultItem = [[NFNRsult alloc]  init];
            _resultItem.parentId = _category.idField;
        }
        _resultItem.createDate = [self stringDate:_dateTextField.text withFormat:@"dd MMMM yyyy" dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
        _resultItem.title = self.textView.text;
        if (isNew) {
            [[NFNSyncManager sharedManager] addResultToDBManager:_resultItem];
        }
        [[NFNSyncManager sharedManager] writeResult:_resultItem];
        [self.navigationController popViewControllerAnimated:YES];
      
    }
}


- (NSString *)stringFromDate:(NSDate *)date {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"dd MMMM yyyy"];
    return [dateFormater stringFromDate:date];
}

- (NSDate*)dateFromString:(NSString*)stringDate {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"dd MMMM yyyy"];
    
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

- (void)deleteAction {
    [[NFNSyncManager sharedManager] removeResultFromDB:_resultItem];
    [[NFNSyncManager sharedManager] removeResultFromDBManager:_resultItem];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
