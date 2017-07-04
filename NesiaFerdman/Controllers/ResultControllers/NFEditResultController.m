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

@interface NFEditResultController ()
@property (weak, nonatomic) IBOutlet NFViewWithDownBorder *mainView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;

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

- (NSString *)stringFromDate:(NSDate *)date {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy HH:mm"];
    return [dateFormater stringFromDate:date];
}

- (void)setStartDataToDisplay {
    self.textView.placeholder = @"Описание";
    if (_resultItem) {
        self.textView.text = self.resultItem.resultDescription;
        self.title = self.category.resultCategoryTitle;
        
    } else {
        self.title = @"Создание";
    }
}

- (void)saveChanges {
    [_indicator startAnimating];
    if (!_resultItem) {
        _resultItem = [[NFResult alloc]  init];
        _resultItem.resultCategoryId = _category.resultCategoryId;
        _resultItem.startDate = [NSString stringWithFormat:@"%@", _selectedDate];
    }
    _resultItem.resultDescription = self.textView.text;
    [[NFSyncManager sharedManager] writeResultToFirebase:_resultItem];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NFSyncManager sharedManager]  updateAllData];
    });
}

- (void)endUpdate {
    [_indicator endAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
