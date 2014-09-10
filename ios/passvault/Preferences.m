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

#import "Preferences.h"

NSString *const OptionKeyObscurePasswords = @"OptionObscurePasswords";
NSString *const OptionKeyCapitaliseEveryWord = @"OptionKeyCapitaliseEveryWord";
NSString *const OptionKeyIncludeSymbol = @"OptionKeyIncludeSymbol";

@implementation Preferences {

}

+ (Preferences *)sharedPrefs {
    static Preferences *sharedPrefs;
    @synchronized (self) {
        if (!sharedPrefs) {
            sharedPrefs = [[Preferences alloc] init];
            NSDictionary *defaultValues = @{OptionKeyObscurePasswords : @NO,
                    OptionKeyCapitaliseEveryWord : @(arc4random() % 2 == 1),
                    OptionKeyIncludeSymbol : @(arc4random() % 2 == 1)};
            [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
        }
    }

    return sharedPrefs;
}

- (BOOL)obscurePasswords {
    return [[NSUserDefaults standardUserDefaults] boolForKey:OptionKeyObscurePasswords];
}

- (BOOL)capitaliseEveryWord {
    return [[NSUserDefaults standardUserDefaults] boolForKey:OptionKeyCapitaliseEveryWord];
}

- (BOOL)includeSymbol {
    return [[NSUserDefaults standardUserDefaults] boolForKey:OptionKeyIncludeSymbol];
}

- (void)setObscurePasswords:(BOOL)obscurePasswords {
    [self saveBool:obscurePasswords key:OptionKeyObscurePasswords];
}

- (void)setIncludeSymbol:(BOOL)includeSymbol {
    [self saveBool:includeSymbol key:OptionKeyIncludeSymbol];
}

- (void)setCapitaliseEveryWord:(BOOL)capitaliseEveryWord {
    [self saveBool:capitaliseEveryWord key:OptionKeyCapitaliseEveryWord];
}

- (void)saveBool:(BOOL)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end