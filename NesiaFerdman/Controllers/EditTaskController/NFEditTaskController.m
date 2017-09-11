//
//  NFEditTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFEditTaskController.h"
#import "NFDatePicker.h"
#import "NFPickerView.h"
#import <UITextView+Placeholder.h>
#import "NFTagView.h"
#import "NFChackBox.h"
#import "NFTagCell.h"
#import "NFActivityIndicatorView.h"
#import "NFSettingManager.h"
#import "NFTextField.h"
#import "NFTextView.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFDataSourceManager.h"
#import "NFNSyncManager.h"
#import "NFNValue.h"
#import "NFAlertController.h"

@interface NFEditTaskController ()
<
UITextViewDelegate,
UITextFieldDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *valueTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *selectValueTextField;
@property (weak, nonatomic) IBOutlet NFTextField *titleOfTaskTextField;
@property (weak, nonatomic) IBOutlet NFTextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UITextField *starttextField;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UILabel *compliteLabel;
@property (weak, nonatomic) IBOutlet NFChackBox *compliteButton;
@property (strong, nonatomic) NFPickerView *valuePicker;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NFDatePicker *datePickerStart;
@property (strong, nonatomic) NFDatePicker *datePickerEnd;
@property (assign, nonatomic) CGRect textFrame;
@property (strong, nonatomic) NSMutableArray *selectedTags;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) CGFloat standartSize;
@end

@implementation NFEditTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    _standartSize = 44.0;
    _isEditing = false;
    self.selectedTags = [NSMutableArray array];
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self setStartDataToDisplay];
    [self configurePickers];
    [self.compliteButton addTarget:self action:@selector(compliteTaskAction) forControlEvents:UIControlEventTouchDown];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NFTagCell" bundle:nil] forCellWithReuseIdentifier:@"NFTagCell"];
    [self.collectionView reloadData];
    [self.deleteButton addTarget:self action:@selector(deleteWithAlert) forControlEvents:UIControlEventTouchUpInside];
    [_titleOfTaskTextField validateWithTarget:self placeholderText:@"Заглавие"];
    [_taskDescriptionTextView validateWithTarget:self
                                 placeholderText:@"Описание" min:0 max:300];
    if (_event) {
        [self setPreviewOptions];
    } else {
        [self setEditOptions];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataToDisplay) name:PICKER_VIEW_IS_PRESSED object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PICKER_VIEW_IS_PRESSED object:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return _textFrame.size.height < 90.f ? 90 : _textFrame.size.height;
    } else if (indexPath.row == 2) {
        return 62.0;
    } else  if (indexPath.row == 0 || indexPath.row == 1) {
        if (!_isEditing) {
            return 0;
        } else {
            return _standartSize;
        }
    } else {
        return UITableViewAutomaticDimension;
    }
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

#pragma mark - Actions

- (IBAction)saveOrCancelAction:(UIBarButtonItem *)sender {
    if (sender.tag == 2) {
        [self saveChanges];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Helpers

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

- (void)setStartDataToDisplay {
    self.taskDescriptionTextView.placeholder = @"Описание";
    [self.deleteButton setTitle:@"Удалить задачу" forState:UIControlStateNormal];
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
    [_selectedTags removeAllObjects];
    [_selectedTags addObjectsFromArray:_event.values];
    if (_event) {
        self.deleteButton.hidden = NO;
        self.titleOfTaskTextField.text = _event.title;
        
        if (_event.eventDescription.length > 0) {
            self.taskDescriptionTextView.text = _event.eventDescription;
        }
        self.starttextField.text = [self stringDate:_event.startDate
                                         withFormat:@"yyyy-MM-dd'T'HH:mm:ss"
                                 dateStringToFromat:@"LLLL, dd, yyyy HH:mm"];
        
        self.endTextField.text = [self stringDate:_event.endDate
                                       withFormat:@"yyyy-MM-dd'T'HH:mm:ss"
                               dateStringToFromat:@"LLLL, dd, yyyy HH:mm"];
        self.compliteButton.selected = _event.isDone;
    } else {
        self.deleteButton.hidden = YES;
        self.title = @"Создание задачи";
        if (_selectedDate != nil) {
            self.starttextField.text = [self stringFromDate:_selectedDate];
            self.endTextField.text = [self stringFromDate:[_selectedDate dateByAddingTimeInterval:900]];
            self.datePickerStart.date = _selectedDate;
            self.datePickerEnd.date = [_selectedDate dateByAddingTimeInterval:900];
        } else {
            self.starttextField.text = [self stringFromDate:[NSDate date]];
            self.endTextField.text = [self stringFromDate:[NSDate  dateWithTimeIntervalSinceNow:900]];
        }
    }
    [self.collectionView reloadData];
}

- (void)configurePickers {
    _datePickerStart = [[NFDatePicker alloc] initWithTextField:_starttextField];
    _datePickerEnd = [[NFDatePicker alloc] initWithTextField:_endTextField];
    _valuesArray = [NSMutableArray arrayWithArray:[[NFDataSourceManager sharedManager] getValueList]];
    _valuePicker = [[NFPickerView alloc] initWithDataArray:_valuesArray textField:_selectValueTextField   keyTitle:@"valueTitle"];
}

- (void)addDataToDisplay {
    if (_selectedTags.count < 2) {
        if (_selectedTags.count == 1) {
            NFNValue *val = [_selectedTags firstObject];
            if ([val.valueId isEqualToString:[_valuePicker.lastSelectedItem valueId]]) {
                NSLog(@"value alredy exist");
            } else {
                [_selectedTags addObject:_valuePicker.lastSelectedItem];
                [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES ] forKey:nil];
                [self.collectionView reloadData];
            }
        } else {
            [_selectedTags addObject:_valuePicker.lastSelectedItem];
            [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES ] forKey:nil];
            [self.collectionView reloadData];
        }
    }
}

- (void)deleteWithAlert {
    if (_event.socialType == NGoogleEvent && [NFSettingManager isOnDeleteFromGoogle]) {
        [NFAlertController alertDeleteGoogleEventWithTarget:self action:@selector(deleteAction)];
    } else {
        [NFAlertController alertDeleteEventWithTarget:self action:@selector(deleteAction)];
    }
}

- (void)deleteAction {
    if ([NFNSyncManager connectedInternet]) {
        _event.isDeleted = true;
        [_indicator startAnimating];
        if ([NFSettingManager isOnDeleteFromGoogle] && _event.socialType == NGoogleEvent ) {
            [[NFNSyncManager sharedManager] deleteEventFromGoogle:_event];
        }
        [[NFNSyncManager sharedManager] removeEventFromDB:_event];
        [[NFNSyncManager sharedManager] removeEventFromDBManager:_event];
        [[NFNSyncManager sharedManager] updateDataSource];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_indicator stopAnimating];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

- (void)compliteTaskAction {
    if ([self valueCount] && [NFNSyncManager connectedInternet]) {
        _compliteButton.selected = !_compliteButton.selected;
        _event.isDone = _compliteButton.selected;
        [[NFNSyncManager sharedManager] writeEventToDataBase:_event];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedTags.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFTagCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"NFTagCell" forIndexPath:indexPath];
    NFNValue *val = [self.selectedTags objectAtIndex:indexPath.item];
    [cell addDataToCell:val isEditMode:_isEditing];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedTags removeObjectAtIndex:indexPath.item];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFNValue *val = [self.selectedTags objectAtIndex:indexPath.item];
    return [NFTagCell calculateSizeWithValue:val isEditMode:_isEditing];
}

- (CATransition *)swipeTransitionToLeftSide:(BOOL)leftSide
{
    CATransition* transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = kCATransitionMoveIn;
    transition.subtype = leftSide ? kCATransitionFromRight : kCATransitionFromTop;
    transition.duration = 0.3;
    return transition;
}

- (void)saveChanges {
    if ([NFNSyncManager connectedInternet]) {
        if ([_titleOfTaskTextField isValidString] && [_taskDescriptionTextView isValidString] && [self periodValidation] && [self valueCountValid]) {
            
            [_indicator startAnimating];
            BOOL newEvent = false;
            if (!_event) {
                _event = [[NFNEvent alloc] init];
                newEvent = true;
            }
            _event.values = [NSMutableArray array];
            _selectedTags.count > 0 ? [_event.values addObjectsFromArray:_selectedTags]: nil;
            _event.title = _titleOfTaskTextField.text;
            _event.eventDescription = _taskDescriptionTextView.text;
            _event.isDone = _compliteButton.selected;
            _event.startDate = [self stringDate:_starttextField.text
                                     withFormat:@"LLLL, dd, yyyy HH:mm"
                             dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
            _event.endDate = [self stringDate:_endTextField.text
                                   withFormat:@"LLLL, dd, yyyy HH:mm"
                           dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            if (newEvent) {
                if ([NFSettingManager isOnWriteToGoogle]) {
                    [[NFNSyncManager sharedManager] addNewEventToGoogle:_event];
                } else {
                    [[NFNSyncManager sharedManager] addEventToDBManager:_event];
                    [[NFNSyncManager sharedManager] writeEventToDataBase:_event];
                    [[NFNSyncManager sharedManager] updateDataSource];
                }
                [self endUpdate];
            } else {
                if ([NFSettingManager isOnWriteToGoogle] && _event.socialType == NGoogleEvent) {
                    [[NFNSyncManager sharedManager] updateGoogleEvent:_event];
                }
                [[NFNSyncManager sharedManager] writeEventToDataBase:_event];
                [self endUpdate];
            }
        }
    }
}

- (void)endUpdate {
    [_indicator endAnimating];
    [self setPreviewOptions];
}

- (void)setPreviewOptions {
    [self setStartDataToDisplay];
    self.isEditing = false;
    self.title = @"Задача";
    UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:@"Изменить" style:UIBarButtonItemStylePlain target:self action:@selector (setEditOptions)];
    self.navigationItem.rightBarButtonItem = rigtButton;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    self.titleOfTaskTextField.userInteractionEnabled = false;
    self.taskDescriptionTextView.userInteractionEnabled = false;
    self.starttextField.userInteractionEnabled = false;
    self.endTextField.userInteractionEnabled = false;
    self.collectionView.userInteractionEnabled = false;
    [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES ] forKey:nil];
    [self.collectionView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)setEditOptions {
    self.isEditing = true;
    if (_event) {
        self.title = @"Редактирование";
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector (setPreviewOptions)];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    } else {
        [self setStartDataToDisplay];
        [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    }
    
    UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStylePlain target:self action:@selector (saveChanges)];
    self.navigationItem.rightBarButtonItem = rigtButton;
    self.titleOfTaskTextField.userInteractionEnabled = true;
    self.taskDescriptionTextView.userInteractionEnabled = true;
    self.starttextField.userInteractionEnabled = true;
    self.endTextField.userInteractionEnabled = true;
    self.collectionView.userInteractionEnabled = true;
    [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES] forKey:nil];
    [self.collectionView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (BOOL)periodValidation {
    if([_datePickerEnd.date compare:_datePickerStart.date] == NSOrderedAscending) {
        [NFPop startAlertWithMassage:kWrongDatesPerion];
        _endTextField.text = _starttextField.text;
        _datePickerEnd.date = _datePickerStart.date;
        return false;
    }
    return true;
}

- (BOOL)valueCountValid {
    if (_selectedTags.count > 0) {
        return true;
    } else {
        [NFPop startAlertWithMassage:kValueCount];
        return false;
    }
}

- (BOOL)valueCount {
    if (_event.values.count > 0) {
        return true;
    } else {
        [NFPop startAlertWithMassage:kValueCount];
        return false;
    }
}

@end
