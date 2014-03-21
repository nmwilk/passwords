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

-(void)writeLabel:(NSString *)label forRow:(NSInteger)row {
    PasswordItem *item = [self.passwordArray objectAtIndex:(NSUInteger) row];
    item.label = label;
}

- (void)writePassword:(NSString *)text forRow:(NSInteger)row {
}

- (void)addNew:(NSString *)label password:(NSString *)password {
    NSInteger uid = [self allocateNewUid];
    PasswordItem *newItem = [[PasswordItem alloc] initWithUid:uid label:label];

    [self.passwordArray addObject:newItem];
    [self sortList];
}

- (void)sortList {
    [self.passwordArray sortUsingComparator:^(PasswordItem *item1, PasswordItem *item2) {
        return [item1.label compare:item2.label];
    }];
}

- (NSInteger)allocateNewUid {
    NSInteger highest = 0;
    for(PasswordItem *passwordItem in self.passwordArray) {
        if (passwordItem.uid > highest) {
            highest = passwordItem.uid;
        }
    }

    return highest + 1;
}
@end