//
//  NFTAddImportantTaskTableViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/5/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTAddImportantTaskTableViewController.h"
#import "NFDatePicker.h"
#import "NFPickerView.h"
#import "NFSyncManager.h"
#import "NFActivityIndicatorView.h"
#import <UITextView+Placeholder.h>
#import "NFChackBox.h"
#import "NotifyList.h"
#import "NFTextField.h"
#import "NFTextView.h"

@interface NFTAddImportantTaskTableViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (assign, nonatomic) CGRect textFrame;
@property (weak, nonatomic) IBOutlet NFTextField *titleTask;
@property (weak, nonatomic) IBOutlet NFTextView *descriptionTask;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) NFDatePicker *datePicker;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *compliteLabel;

@end

@implementation NFTAddImportantTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionTask.placeholder = @"Описание";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.dateTextField.text = [self stringFromDate:[NSDate date]];
    _datePicker = [[NFDatePicker alloc] initWithTextField:_dateTextField];
    [_titleTask validateWithTarget:self placeholderText:@"Заглавие"];
    [_descriptionTask validateWithTarget:self placeholderText:@"Описание" min:0 max:300];
    _datePicker.minimumDate = [NSDate date];
    [self setStartDataToDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endUpdate) name:END_UPDATE_DATA object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA object:nil];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.f;
    } else {
        return 30.f;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return _textFrame.size.height < 150.f ? 150 : _textFrame.size.height;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.item == 0) {
            [_dateTextField becomeFirstResponder];
        } else if (indexPath.item == 1) {
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Helpers

- (IBAction)pressSaveOrCancelAction:(UIBarButtonItem *)sender {
    if (sender.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (sender.tag == 2) {
        [self saveChanges];
    }
}

- (void)endUpdate {
    [_indicator endAnimating];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextView

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    if (newFrame.size.height != textView.frame.size.height) {
        textView.frame = newFrame;
        self.textFrame = newFrame;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [textView becomeFirstResponder];
    }
}

#pragma mark - Helpers 

- (void)setStartDataToDisplay {
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
    if (_event) {
        self.title = @"Редактирование";
        [self.saveButton setTitle:@"Изменить"];
        self.dateTextField.text = [self stringDate:_event.startDate
                                        withFormat:@"yyyy-MM-dd'T'HH:mm:ss"
                                dateStringToFromat:@"LLLL, dd, yyyy HH:mm"];
        self.titleTask.text = _event.title;
        if (_event.eventDescription.length > 0) {
            self.descriptionTask.text = _event.eventDescription;
        }
    } else {
        [self.saveButton setTitle:@"Сохранить"];
        self.title = @"Создание записи";
    }
}

- (NSString *)stringFromDate:(NSDate *)date {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy HH:mm"];
    return [dateFormater stringFromDate:date];
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

- (void)saveChanges {
    if ([_titleTask isValidString]) {
    [_indicator startAnimating];
    if (!_event) {
        _event = [[NFEvent alloc] init];
    }
    _event.eventType = self.eventType;
    _event.title = _titleTask.text;
    _event.eventDescription = _descriptionTask.text;
    _event.startDate = [self stringDate:_dateTextField.text
                             withFormat:@"LLLL, dd, yyyy HH:mm"
                     dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [[NFSyncManager sharedManager] writeEventToFirebase:_event];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NFSyncManager sharedManager]  updateAllData];
    });
    }
}

@end
