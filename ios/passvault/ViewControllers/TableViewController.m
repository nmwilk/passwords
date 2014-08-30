// Copyright 2014 Neil Wilkinson
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#import "TableViewController.h"
#import "TitleBanner.h"
#import "PasswordList.h"
#import "PasswordViewController.h"
#import "QuickView.h"
#import "UIViewController+MFSideMenuAdditions.h"
#import "MFSideMenuContainerViewController.h"
#import "AddButton.h"
#import "PasswordTableCell.h"
#import "JNKeychainPasswordStore.h"

#define kCellIdPassword @"PasswordCellView"

@interface TableViewController ()
@property(nonatomic, strong) UIBarButtonItem *addButton;
@end

@implementation TableViewController {
    PasswordList *passwordList;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadPasswords];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadPasswords];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createToolbar];

    [self.titleBanner.editButton addTarget:self action:@selector(editButtonTapped)
                          forControlEvents:UIControlEventTouchUpInside];

    [self.titleBanner.menuButton addTarget:self action:@selector(menuButtonTapped)
                          forControlEvents:UIControlEventTouchUpInside];

    [self.tableView addGestureRecognizer:[[LongTapGestureRecogniser alloc] initWithTarget:self]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];

    [self updateEditButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [passwordList savePasswordsInfos];
}

- (void)longTapAtPoint:(CGPoint)point withIndexPath:(NSIndexPath *)indexPath {
    NSString *const string = [passwordList password:(NSUInteger) indexPath.row];
    if (string != nil && [string length] > 0) {
        [self.quickView showWithText:string atPoint:point];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)longTapEnded {
    [self.quickView hide];
}

- (void)addButtonTapped {
    PasswordViewController *const vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"PasswordViewController"];
    [vc configureForNewPasswordWithPasswordList:passwordList];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)editButtonTapped {
    const BOOL isEditing = self.tableView.isEditing;

    [self updateButtonsForEditState:!isEditing];

    [self.tableView setEditing:!isEditing animated:YES];
}

- (void)menuButtonTapped {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)loadPasswords {
    passwordList = [[PasswordList alloc] initWithPasswordStore:[[JNKeychainPasswordStore alloc] init]];
}

- (void)createToolbar {
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil action:nil];

    self.addButton = [[AddButton alloc] initWithTarget:self action:@selector(addButtonTapped)];

    [self.toolbar setItems:@[flexibleSpace, self.addButton, flexibleSpace]];
}

- (void)updateButtonsForEditState:(BOOL const)isEditing {
    self.titleBanner.menuButton.enabled = !isEditing;
    self.addButton.enabled = !isEditing;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)openEditScreen:(NSInteger)row {
    PasswordViewController *const vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"PasswordViewController"];
    [vc configureForEditPasswordWithPasswordList:passwordList row:row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateButtonsForEditState:YES];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateButtonsForEditState:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    [passwordList deleteAtIndex:(NSUInteger) index];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

    [passwordList savePasswordsInfos];

    if (passwordList.count == 0 && self.tableView.isEditing)
    {
        [self editButtonTapped];
    }

    [self updateEditButton];
}

- (void)updateEditButton {
    self.titleBanner.editButton.enabled = passwordList.count > 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        [self openEditScreen:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        PasswordTableCell *const cell = (PasswordTableCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (!cell.animating) {
            NSString *const string = [passwordList password:(NSUInteger) indexPath.row];
            if (string != nil && [string length] > 0) {
                [UIPasteboard generalPasteboard].string = string;
                [cell animateCopyNotification];
            }
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [passwordList count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PasswordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdPassword];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PasswordListCell" owner:self options:nil];
        cell = nib[0];
    }

    cell.titleLabel.text = [passwordList label:(NSUInteger) indexPath.row];

    return cell;
}

@end