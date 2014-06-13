//
// Created by Neil on 13/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "Preferences.h"

NSString *const OptionKeyObscurePasswords = @"OptionObscurePasswords";

@implementation Preferences {

}

+(Preferences*)sharedPrefs {
    static Preferences *sharedPrefs;
    @synchronized (self) {
        if (!sharedPrefs) {
            sharedPrefs = [[Preferences alloc] init];
        }
    }

    return sharedPrefs;
}

-(BOOL)obscurePasswords {
    return [[NSUserDefaults standardUserDefaults] boolForKey:OptionKeyObscurePasswords];
}

-(void)setObscurePasswords:(BOOL)obscurePasswords {
    [[NSUserDefaults standardUserDefaults] setBool:obscurePasswords forKey:OptionKeyObscurePasswords];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end