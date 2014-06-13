//
// Created by Neil on 13/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor* switchColour = [UIColor colorWithRed:0.0 green:0.5 blue:1.0f alpha:1.0f];

    for (UIView *subview in self.view.subviews) {
        if ([subview class] == [UISwitch class]) {
            [((UISwitch *) subview) setOnTintColor:switchColour];
        }
    }
}

@end