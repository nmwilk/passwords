//
// Created by Neil on 18/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PasswordViewController.h"

@class PasswordList;

@interface EditPasswordViewController : PasswordViewController

- (void)configureWithPasswordList:(PasswordList *)list row:(NSInteger)row;

@end