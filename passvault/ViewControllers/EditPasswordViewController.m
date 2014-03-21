//
// Created by Neil on 18/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "PasswordList.h"


@interface EditPasswordViewController ()
@property(nonatomic) NSInteger editedItem;
@property(nonatomic, copy) NSString *labelText;
@property(nonatomic, copy) NSString *passwordText;
@end

@implementation EditPasswordViewController {

}

- (void)configureWithPasswordList:(PasswordList *)list row:(NSInteger)row {
    self.list = list;
    self.editedItem = row;
    self.labelText = [list label:(NSUInteger) row];
    self.passwordText = [list password:(NSUInteger) row];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelField.text = self.labelText;
    self.passwordField.text = self.passwordText;
    
    self.passwordText = nil;
}

-(IBAction)done {
    [self.list writeLabel:self.labelField.text forRow:self.editedItem];
    [self.list writePassword:self.passwordField.text forRow:self.editedItem];
    [self.list savePasswords];
    [super done];
}

@end