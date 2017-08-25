//
//  NFAddValueCategoryController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAddValueCategoryController.h"
#import "NFActivityIndicatorView.h"
#import <UITextView+Placeholder.h>
#import "UIBarButtonItem+FHButtons.h"
#import "NotifyList.h"
#import "NFTextView.h"
#import "NFNSyncManager.h"

@interface NFAddValueCategoryController ()
@property (weak, nonatomic) IBOutlet NFTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
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
    [_deleteButton setTitle:@"Удалить" forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveChanges {
    if ([self.textView isValidString]) {
        if (!_manifestation) {
            _manifestation = [NFNManifestation new];
            _isNew = true;
        }
        _manifestation.title = _textView.text;
        _manifestation.parentId = _value.valueId;
        if (_isNew) {
            [[NFNSyncManager sharedManager] writeManifestationToDataBase:_manifestation toValue:_value];
            [[NFNSyncManager sharedManager] addManifestationToDBManager:_manifestation];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)deleteAction {
    [[NFNSyncManager sharedManager] removeManifestationDBFromManager:_manifestation];
    [[NFNSyncManager sharedManager] removeManifestationDB:_manifestation];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)setStartDateTodisplay {
    if (_manifestation) {
        self.textView.text = _manifestation.title;
    }
}

@end
