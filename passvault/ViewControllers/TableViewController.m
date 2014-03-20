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

#define kTitleEdit @"Edit"
#define kTitleDone @"Done"

#define kPrefsPasswordIds @"passwordIds"

#define kCellIdPassword @"passwordCell"

@interface TableViewController ()

@end

NSMutableDictionary *gDictionary;
NSArray *wordLengths;

@implementation TableViewController {
    BOOL inEditMode;
    NSMutableDictionary *passwords;
    NSArray *passwordLabels;
    NSComparator alphabeticOrderer;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadDictionary];
        [self loadPasswords];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadDictionary];
        [self loadPasswords];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self createToolbar];
    
    [self.titleBanner.editButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self savePasswords];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [passwordLabels count];
    }

    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdPassword];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdPassword];
    }

    cell.textLabel.text = [passwordLabels objectAtIndex:indexPath.row];

    return cell;
}

- (void)loadPasswords {
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *storedPasswords = [userPrefs dictionaryForKey:kPrefsPasswordIds];

    if (storedPasswords == nil) {
        passwords = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"iTunes", nil];
    } else {
        passwords = [storedPasswords mutableCopy];
    }

    passwordLabels = [passwords keysSortedByValueUsingComparator:^(NSString* obj1, NSString* obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
}

-(void)savePasswords {
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    [userPrefs setObject:passwords forKey:kPrefsPasswordIds];
    [userPrefs synchronize];
}

- (void)createToolbar {
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];

    [self.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, addButton, flexibleSpace, nil]];
}

- (void)editButtonTapped {

    NSString *newTitle = inEditMode ? kTitleEdit : kTitleDone;

    [self.titleBanner.editButton setTitle:newTitle forState:UIControlStateNormal];

    if (inEditMode) {

    } else {
        
    }

    inEditMode = !inEditMode;
}

-(void)openEditScreen {
    EditPasswordViewController *const vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"EditPasswordViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addButtonTapped {
    AddPasswordViewController *const vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AddPasswordViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loadDictionary {
    wordLengths = [NSArray arrayWithObjects:@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    gDictionary = [[NSMutableDictionary alloc] init];

    for(NSString *wordLength in wordLengths) {

        NSString *filePath = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"enable1_%@", wordLength] ofType:@"txt"];
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSString* delimiter = @"\n";
        NSArray *fileAsArray = [fileContent componentsSeparatedByString:delimiter];
        [gDictionary setObject:fileAsArray forKey:wordLength];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end