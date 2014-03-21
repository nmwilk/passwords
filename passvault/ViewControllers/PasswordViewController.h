//
// Created by Neil on 18/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PasswordList;


@interface PasswordViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UITextField *labelField;
@property(nonatomic, strong) IBOutlet UITextField *passwordField;
@property(nonatomic, strong) PasswordList *list;

- (IBAction)cancelled;

- (IBAction)done;

@end