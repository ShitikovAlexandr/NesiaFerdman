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
#import "NFPop.h"
#import "UIBarButtonItem+FHButtons.h"

#define kDone       @"Готово"
#define kEdit       @"Изменить"
#define kCancel     @"Отмена"


@interface NFValueMainDataSource () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) TPKeyboardAvoidingTableView *tableView;
@property (strong, nonatomic) NSMutableArray *deletedValues;
@property (strong, nonatomic) NFValueController *target;
@end

@implementation NFValueMainDataSource

- (instancetype)initWithTableView:(TPKeyboardAvoidingTableView*)tableView target:(NFValueController*)target {
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
    if (self.dataArray.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_target.indicator endAnimating];
        });
    }
}

- (void)saveChanges {
    
    if (_deletedValues.count > 0) {
        for (NFNValue *val in _deletedValues) {
            [[NFNSyncManager sharedManager] removeValueFromDB:val];
            [[NFNSyncManager sharedManager] removeValueFromDBManager:val];
        }
    }
        [_deletedValues removeAllObjects];
        NSMutableArray *newArray = [NSMutableArray array];
        [newArray addObjectsFromArray:[self updateIndexInValuesArray:_dataArray]];
        [self saveValuesArrayToDataBase:newArray];
}

- (void)saveValuesArrayToDataBase:(NSMutableArray*)array {
    for (NFNValue *val in array) {
        [[NFNSyncManager sharedManager] writeValueToDataBase:val];
    }
    [[NFNSyncManager sharedManager] updateData];
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
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (value.length > 0) {
        NFNValue *newValue = [[NFNValue alloc] init];
        newValue.valueTitle = value;
        newValue.valueIndex = index;
        [[NFNSyncManager sharedManager] addValueToDBManager:newValue];
        [[NFNSyncManager sharedManager] writeValueToDataBase:newValue];
        [_dataArray addObject:newValue];
        [self.tableView reloadData];
    }
}


#pragma mark - navigations buttons actions

- (void)setNavButtonForFirstRun {
    [_tableView setEditing:YES animated:YES];
    [_target.navigationItem.rightBarButtonItem setTitle:@"Готово"];
    
}

- (BOOL)validateValue:(NSArray*)valueArray {
    if (valueArray.count > 11) {
        [NFPop startAlertWithMassage:kValueMaxCount];
        return false;
    } else if (valueArray.count < 7) {
        [NFPop startAlertWithMassage:kValueMinCount];
        return false;
    } else {
        return true;
    }
}

- (void)exitAction {
    [_target dismissViewControllerAnimated:YES completion:nil];
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
    NFNValue *value = [_dataArray objectAtIndex:indexPath.row];
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
    if (_target.screenState == FirstRunValue) {
        [self saveChanges];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
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
    
    if (_target.screenState == FirstRunValue) {
        [self saveChanges];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"text field text %@ end!!!",textField.text);
    [textField resignFirstResponder];
    [self addNewValueWithName:textField.text andIndex:_dataArray.count];
    textField.text = @"";
    [self setScreenState:_target.screenState];
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
    [self setScreenState:ViewValue];
}

- (void)rightButtonsAction {
    switch (_target.screenState) {
        case ViewValue: {
            
            [self setScreenState:EditValue];
            break;
        }
        case EditValue: {
            if ([self validateValue:_dataArray]) {
                [self saveChanges];
                [self setScreenState:ViewValue];
            }
           
            break;
        }
        case FirstRunValue: {
            if ([self validateValue:_dataArray]) {
                [self saveChanges];
                [_target.navigationController setNavigationBarHidden:YES];
                [_target.navigationController pushViewController:_target.nextController animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

- (void)leftButtonsAction {
    
    switch (_target.screenState) {
        case ViewValue: {
            [self exitAction];
            break;
        }
        case EditValue: {
            [self setScreenState:ViewValue];
            [self getData];
                       break;
        }
        case FirstRunValue: {
            break;
        }
        default:
            break;
    }
}

- (void)setScreenState:(ValueScreenState)state {
    switch (state) {
        case ViewValue:{
            _target.screenState = ViewValue;
            [_tableView setEditing:NO animated:YES];
            UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:kEdit style:UIBarButtonItemStylePlain target:self action:@selector (rightButtonsAction)];
            _target.navigationItem.rightBarButtonItem = rigtButton;
            _target.navigationItem.rightBarButtonItem.customView.hidden = NO;
            
            UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_standart"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonsAction)];
            _target.navigationItem.leftBarButtonItem = backBarButtonItem;
            break;
        }
            
        case EditValue:{
            _target.screenState = EditValue;
            [_tableView setEditing:YES animated:YES];
            [self getData];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:kCancel  style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonsAction)];
            _target.navigationItem.leftBarButtonItem = cancelButton;
            
            UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:kDone style:UIBarButtonItemStylePlain target:self action:@selector (rightButtonsAction)];
            _target.navigationItem.rightBarButtonItem = rigtButton;
            _target.navigationItem.rightBarButtonItem.customView.hidden = NO;
            break;
        }
            
        case FirstRunValue:{
            _target.screenState = FirstRunValue;
            [_tableView setEditing:YES animated:YES];
            UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:kDone style:UIBarButtonItemStylePlain target:self action:@selector (rightButtonsAction)];
            _target.navigationItem.rightBarButtonItem = rigtButton;
            _target.navigationItem.rightBarButtonItem.customView.hidden = NO;
            [_target.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:_target];
            break;
        }
        default:
            break;
    }
}

#pragma mark - navigation

- (void)navigateToDetailWithValue:(NFNValue*)value {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    NFValueDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NFValueDetailController class])];
    viewController.value = value;
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFValueDetailControllerNav"];
    [navController setViewControllers:@[viewController]];
    [_target presentViewController:navController animated:YES completion:nil];
}


@end
