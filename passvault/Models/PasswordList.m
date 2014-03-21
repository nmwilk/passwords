//
// Created by Neil on 20/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "PasswordList.h"
#import "PasswordItem.h"

#define kPrefsPasswordIds @"passwords"

@implementation PasswordList {
}

- (id)init {
    self = [super init];
    if (self) {

        NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
        NSData *passwordArrayData = [userPrefs objectForKey:kPrefsPasswordIds];

        if (passwordArrayData == nil) {
            _passwordArray = [[NSMutableArray alloc] init];
            [_passwordArray addObject:[[PasswordItem alloc] initWithUid:1 label:@"iTunes"]];
        } else {
            _passwordArray = [NSKeyedUnarchiver unarchiveObjectWithData:passwordArrayData];
        }
    }

    return self;
}

- (void)savePasswords {
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passwordArray];
    [userPrefs setObject:data forKey:kPrefsPasswordIds];
    [userPrefs synchronize];

    for (PasswordItem *item in self.passwordArray) {
        // TODO write all passwords
    }
}

- (NSUInteger)count {
    return [self.passwordArray count];
}

- (NSString *)password:(NSUInteger)index {
    // TODO just set as label for now. But need to use uid to lookup password in secure store.
    NSString *found = ((PasswordItem *) [self.passwordArray objectAtIndex:index]).label;

    return found;
}

- (NSString *)label:(NSUInteger)index {
    id const o = [self.passwordArray objectAtIndex:index];
    return ((PasswordItem *) o).label;
}

@end