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
    [self.capitaliseEveryWord setOn:[Preferences sharedPrefs].capitaliseEveryWord];
    [self.includeSymbol setOn:[Preferences sharedPrefs].includeSymbol];
}

- (void)switchToggled:(UISwitch *)switchToggled {
    if (switchToggled == self.obscurePasswords) {
        [Preferences sharedPrefs].obscurePasswords = self.obscurePasswords.on;
    } else if (switchToggled == self.capitaliseEveryWord) {
        [Preferences sharedPrefs].capitaliseEveryWord = self.capitaliseEveryWord.on;
    } else if (switchToggled == self.includeSymbol) {
        [Preferences sharedPrefs].includeSymbol = self.includeSymbol.on;
    }
}

@end