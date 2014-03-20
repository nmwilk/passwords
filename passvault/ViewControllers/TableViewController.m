//
//  TableViewController.m
//  passvault
//
//  Created by Neil on 26/02/2014.
//  Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "TableViewController.h"
#import "EditPasswordViewController.h"
#import "AddPasswordViewController.h"
#import "TitleBanner.h"
#import "PasswordTableCell.h"
#import "PasswordList.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [self createToolbar];

    [self.titleBanner.editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated {
    [passwordList savePasswords];
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
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];

    [self.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, self.addButton, flexibleSpace, nil]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        [self openEditScreen];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        PasswordTableCell *const cell = (PasswordTableCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (!cell.animating) {
            [UIPasteboard generalPasteboard].string = [passwordList password:(NSUInteger) indexPath.row];
            [cell animateCopyNotification];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }

}

- (void)editButtonTapped {

    const BOOL isEditing = self.tableView.isEditing;
    NSString *newTitle = isEditing ? kTitleEdit : kTitleDone;

    [self.titleBanner.editButton setTitle:newTitle forState:UIControlStateNormal];

    self.addButton.enabled = isEditing;

    [self.tableView setEditing:!isEditing animated:YES];
}

- (void)openEditScreen {
    EditPasswordViewController *const vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"EditPasswordViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addButtonTapped {
    AddPasswordViewController *const vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AddPasswordViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loadDictionary {
    wordLengths = [NSArray arrayWithObjects:@"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    gDictionary = [[NSMutableDictionary alloc] init];

    for (NSString *wordLength in wordLengths) {

        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"enable1_%@", wordLength] ofType:@"txt"];
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSString *delimiter = @"\n";
        NSArray *fileAsArray = [fileContent componentsSeparatedByString:delimiter];
        [gDictionary setObject:fileAsArray forKey:wordLength];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end