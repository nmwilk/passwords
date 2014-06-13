//
//  TableViewController.m
//  passvault
//
//  Created by Neil on 26/02/2014.
//  Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "TableViewController.h"
#import "TitleBanner.h"
#import "PasswordTableCell.h"
#import "PasswordList.h"
#import "PasswordViewController.h"
#import "QuickView.h"
#import "UIViewController+MFSideMenuAdditions.h"
#import "MFSideMenuContainerViewController.h"

#define kTitleEdit @"Edit"
#define kTitleDone @"Done"

#define kCellIdPassword @"PasswordCellView"

@interface TableViewController ()
@property(nonatomic, strong) UIBarButtonItem *addButton;
@end

NSMutableDictionary *gDictionary;
NSArray *wordLengths;

@implementation TableViewController {
    PasswordList *passwordList;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadDictionary];
        [self loadPasswords];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadDictionary];
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

- (void)longTapAtPoint:(CGPoint)point withIndexPath:(NSIndexPath *)indexPath {
    NSString *const string = [passwordList password:(NSUInteger) indexPath.row];
    if (string != nil && [string length] > 0) {
        [self quickViewPassword:string atPosition:point];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)longTapEnded {
    [self hideQuickView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
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
                [self copyPassword:cell string:string];
            }
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (void)copyPassword:(PasswordTableCell *const)cell string:(NSString *const)string {
    [UIPasteboard generalPasteboard].string = string;
    [cell animateCopyNotification];
}

- (void)quickViewPassword:(NSString *const)string atPosition:(CGPoint)point {
    if (self.quickView.hidden) {
        self.quickView.password.text = string;
        [self showQuickView:point];
    }
}

- (void)showQuickView:(CGPoint)point {
    self.quickView.alpha = 0.0f;
    self.quickView.hidden = NO;
    self.quickView.center = CGPointMake(point.x, point.y);
    [self.quickView layer].transform = CATransform3DMakeScale(0.6f, 0.6f, 1.0f);
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionTransitionNone | UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
        self.quickView.alpha = 1.0f;
        [self.quickView layer].transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
    }
                     completion:^(BOOL finished) {
    }];
}

- (void)hideQuickView {
    [UIView animateWithDuration:0.5f delay:0.0f
         usingSpringWithDamping:0.5f initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionTransitionNone | UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
        self.quickView.alpha = 0.0f;
    }
                     completion:^(BOOL finished) {
        self.quickView.hidden = YES;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [passwordList savePasswordsInfos];
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
        cell = [nib objectAtIndex:0];
    }

    cell.titleLabel.text = [passwordList label:(NSUInteger) indexPath.row];

    return cell;
}

- (void)loadPasswords {
    passwordList = [[PasswordList alloc] init];
}

- (void)createToolbar {
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil action:nil];
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                   action:@selector(addButtonTapped)];

    [self.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, self.addButton, flexibleSpace, nil]];
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
}

- (void)editButtonTapped {
    const BOOL isEditing = self.tableView.isEditing;
    NSString *newTitle = isEditing ? kTitleEdit : kTitleDone;

    [self.titleBanner.editButton setTitle:newTitle forState:UIControlStateNormal];

    self.addButton.enabled = isEditing;

    [self.tableView setEditing:!isEditing animated:YES];
}

-(void)menuButtonTapped {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)openEditScreen:(NSInteger)row {
    PasswordViewController *const vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"PasswordViewController"];
    [vc configureForEditPasswordWithPasswordList:passwordList row:row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addButtonTapped {
    PasswordViewController *const vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"PasswordViewController"];
    [vc configureForNewPasswordWithPasswordList:passwordList];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loadDictionary {
    wordLengths = [NSArray arrayWithObjects:@"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    gDictionary = [[NSMutableDictionary alloc] init];

    for (NSString *wordLength in wordLengths) {

        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"enable1_%@",
                                                                                               wordLength]
                                                             ofType:@"txt"];
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSString *delimiter = @"\n";
        NSArray *fileAsArray = [fileContent componentsSeparatedByString:delimiter];
        [gDictionary setObject:fileAsArray forKey:wordLength];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end