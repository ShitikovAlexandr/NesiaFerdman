//
//  NFAddValueCategoryController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAddValueCategoryController.h"
#import "NFActivityIndicatorView.h"
#import <UITextView+Placeholder.h>
#import "UIBarButtonItem+FHButtons.h"

#import "NotifyList.h"
#import "NFTaskManager.h"
#import "NFTextView.h"
#import "NFSyncManager.h"


@interface NFAddValueCategoryController ()
@property (weak, nonatomic) IBOutlet NFTextView *textView;
@property (assign, nonatomic) BOOL isNew;

@end

@implementation NFAddValueCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _value.valueTitle;
    [_textView validateWithTarget:self placeholderText:@"Описание" min:1 max:300];
    [self setNavigationButtons];
    [self setStartDateTodisplay];
    [self.textView becomeFirstResponder];
}


#pragma mark - Helpers

- (void)setNavigationButtons {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStylePlain target:self action:@selector(saveChanges)];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
}

- (void)saveChanges {
    if ([self.textView isValidString]) {
        if (!_manifestation) {
            _manifestation = [NFManifestation new];
            _isNew = true;
        }
        _manifestation.name = _textView.text;
        _manifestation.categoryKey = _value.valueId;
        if (_isNew) {
            [_value.manifestations addObject:_manifestation];
        }
        [[NFSyncManager sharedManager] addMainifestation:_manifestation toValue:_value];
        [[NFSyncManager sharedManager]  updateAllData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setStartDateTodisplay {
    if (_manifestation) {
        self.textView.text = _manifestation.name;
    }
}

@end
