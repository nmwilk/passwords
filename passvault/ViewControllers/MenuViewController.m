//
// Created by Neil on 13/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "MenuViewController.h"
#import "Preferences.h"
#import "UIColor+AppColors.h"

@implementation MenuViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    for (UIView *subview in self.view.subviews) {
        if ([subview class] == [UISwitch class]) {
            UISwitch *const switchControl = (UISwitch *) subview;
            [switchControl setOnTintColor:[UIColor mainColour]];

            [switchControl addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
        }
    }

    [self.obscurePasswords setOn:[Preferences sharedPrefs].obscurePasswords];
}

- (void)switchToggled:(UISwitch *)switchToggled {
    if (switchToggled == self.obscurePasswords) {
        [Preferences sharedPrefs].obscurePasswords = self.obscurePasswords.on;
    }
}

@end