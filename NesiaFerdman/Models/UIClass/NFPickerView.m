//
//  NFPickerView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/5/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFPickerView.h"
#import "NotifyList.h"

@interface NFPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UITextField *textfield;
@property (strong, nonatomic) UIToolbar *toolBar;

@property (strong ,nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString *keyTitle;
@end

@implementation NFPickerView

- (instancetype) initWithDataArray:(NSArray *)array
                         textField:(UITextField *)textField
                          keyTitle:(NSString *)keyForTitle {
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObjectsFromArray:array];
        self.delegate = self;
        self.dataSource = self;
        self.keyTitle = keyForTitle;
        
        self.textfield = textField;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, -3.0f);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 3;
        self.layer.masksToBounds = NO;
        
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        [self.toolBar setTintColor:[UIColor grayColor]];
        [self.toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [textField setInputAccessoryView:self.toolBar];
        [textField setInputView:self];
    }
    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [[self.dataArray objectAtIndex:row] valueForKey:_keyTitle];
    return title;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = [NSNumber numberWithInteger:row];
}

#pragma mark - Helpers

- (void)doneButtonPressed:(id)sender {
    if (_dataArray.count > 0) {
        _lastSelectedItem = [self.dataArray objectAtIndex:[self.selectedIndex integerValue]];
        NSNotification *notification = [NSNotification notificationWithName:PICKER_VIEW_IS_PRESSED object:self];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
    [self.textfield resignFirstResponder];
}

- (void)resignView {
     [self.textfield resignFirstResponder];
}

@end
