//
// Created by Neil on 13/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "MenuViewController.h"
#import "Preferences.h"

@implementation MenuViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *switchColour = [UIColor colorWithRed:0.0 green:0.5 blue:1.0f alpha:1.0f];

    for (UIView *subview in self.view.subviews) {
        if ([subview class] == [UISwitch class]) {
            UISwitch *const switchControl = (UISwitch *) subview;
            [switchControl setOnTintColor:switchColour];

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