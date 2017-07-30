//
//  NFValueMainDataSource.m
//  NesiaFerdman
//
//  Created by Alex on 30.07.17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueMainDataSource.h"
#import "NFDataSourceManager.h"
#import "NFNSyncManager.h"
#import "NFValueDetailController.h"
#import "NFValueCell.h"
#import "NFStyleKit.h"
#import "NFNEvent.h"


@interface NFValueMainDataSource () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) TPKeyboardAvoidingTableView *tableView;
@property (strong, nonatomic) NSMutableArray *deletedValues;
@property (strong, nonatomic) UIViewController *target;
@end

@implementation NFValueMainDataSource

- (instancetype)initWithTableView:(TPKeyboardAvoidingTableView*)tableView target:(UIViewController*)target {
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray new];
        _deletedValues = [NSMutableArray new];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _target = target;
        [self.tableView registerNib:[UINib nibWithNibName:@"NFValueCell" bundle:nil] forCellReuseIdentifier:@"NFValueCell"];
        [NFStyleKit foterViewWithAddTextFieldtoTableView:_tableView withTarget:self];

    }
    return self;
}

#pragma mark - data methods (save/get)

- (void)getData {
    [[NFNSyncManager sharedManager] updateValueDataSource];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getValueList]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)saveChanges {
    if (_deletedValues.count > 0) {
        for (NFNValue *val in _deletedValues) {
            [[NFNSyncManager sharedManager] removeValueFromDB:val];
            [[NFNSyncManager sharedManager] removeValueFromDBManager:val];
        }
        [_deletedValues removeAllObjects];
    }
    
    NSMutableArray *newArray = [NSMutableArray array];
    [newArray addObjectsFromArray:[self updateIndexInValuesArray:_dataArray]];
    [self saveValuesArrayToDataBase:newArray];
}

- (void)saveValuesArrayToDataBase:(NSMutableArray*)array {
    for (NFNValue *val in array) {
        [[NFNSyncManager sharedManager] writeValueToDataBase:val];
    }
}

- (NSMutableArray *)updateIndexInValuesArray:(NSMutableArray*)inputArray {
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < inputArray.count; i++) {
        NFNValue *val = [inputArray objectAtIndex:i];
        val.valueIndex = i;
        [result addObject:val];
    }
    return result;
}

- (void)addNewValueWithName:(NSString*)value andIndex:(NSInteger)index {
    if (value.length > 0) {
        NFNValue *newValue = [[NFNValue alloc] init];
        newValue.valueTitle = value;
        newValue.valueIndex = index;
        [[NFNSyncManager sharedManager] addValueToDBManager:newValue];
        [[NFNSyncManager sharedManager] writeValueToDataBase:newValue];
    }
    [self getData];
    [self addNavigationButtons];
}

#pragma mark - navigations buttons actions

- (void)addNavigationButtons {
    [self addNavigationButton];
    
    UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:@"Изменить" style:UIBarButtonItemStylePlain target:self action:@selector (editButtonAction)];
    _target.navigationItem.rightBarButtonItem = rigtButton;
    _target.navigationItem.rightBarButtonItem.customView.hidden = NO;
}

- (void)addNavigationButton {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_standart"] style:UIBarButtonItemStylePlain target:self action:@selector(exitAction)];
    _target.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)addCancelButton {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена"  style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    _target.navigationItem.leftBarButtonItem = cancelButton;
}

- (IBAction) editButtonAction {
    [_tableView setEditing:!_tableView.editing animated:YES];
    
    if (_tableView.editing) {
        [_target.navigationItem.rightBarButtonItem setTitle:@"Готово"];
        [self addCancelButton];
    } else {
        [_target.navigationItem.rightBarButtonItem setTitle:@"Изменить"];
        [self saveChanges];
        [self addNavigationButton];
    }
}


- (void)exitAction {
    [_target dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAction {
    [_tableView setEditing:NO animated:YES];
    [self addNavigationButton];
    [_target.navigationItem.rightBarButtonItem setTitle:@"Изменить"];
    [self getData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFValueCell"];
    cell.showsReorderControl = YES;
    NFValue *value = [_dataArray objectAtIndex:indexPath.row];
    [cell addData:value];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFValue *value = [_dataArray objectAtIndex:indexPath.row];
    [self navigateToDetailWithValue:value];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_deletedValues addObject:[_dataArray objectAtIndex:indexPath.row]];
        [_dataArray removeObjectAtIndex:indexPath.row];
        if (_dataArray.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } else {
            [_tableView reloadData];
        }
    }
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    id object = [_dataArray objectAtIndex:sourceRow];
    
    [_dataArray removeObjectAtIndex:sourceRow];
    [_dataArray insertObject:object atIndex:destRow];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"text field text %@ end!!!",textField.text);
    [textField resignFirstResponder];
    [self addNewValueWithName:textField.text andIndex:_dataArray.count];
    textField.text = @"";
    [self addNavigationButtons];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"new value");
    _target.navigationItem.rightBarButtonItem = nil;
    _target.navigationItem.leftBarButtonItem = nil;
    [_tableView setEditing:NO animated:YES];
}

- (void)updateData {
    [self getData];
    [self addNavigationButtons];
}


#pragma mark - navigation

- (void)navigateToDetailWithValue:(NFValue*)value {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    NFValueDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NFValueDetailController class])];
    viewController.value = value;
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFValueDetailControllerNav"];
    [navController setViewControllers:@[viewController]];
    [_target presentViewController:navController animated:YES completion:nil];
}


@end
