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

// Stores actual passwords in a secure store. The label and uid (used to look it up) is stored in NSUserDefaults.

#import "PasswordList.h"
#import "PasswordInfoItem.h"
#import "PasswordStore.h"

#define kPrefsPasswordIds @"passwords"

@interface PasswordList ()
@property(nonatomic, strong) id <PasswordStore> passwordStore;
@end

@implementation PasswordList {
}

- (id)initWithPasswordStore:(id <PasswordStore>)passwordStore {
    self = [super init];
    if (self) {

        self.passwordStore = passwordStore;

        NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
        NSData *passwordInfoData = [userPrefs objectForKey:kPrefsPasswordIds];

        if (passwordInfoData == nil) {
            _passwordInfoData = [[NSMutableArray alloc] init];
            [_passwordInfoData addObject:[[PasswordInfoItem alloc] initWithUid:1 label:@"iTunes"]];
        } else {
            _passwordInfoData = [NSKeyedUnarchiver unarchiveObjectWithData:passwordInfoData];
        }
    }

    return self;
}

- (void)savePasswordsInfos {
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passwordInfoData];
    [userPrefs setObject:data forKey:kPrefsPasswordIds];
    [userPrefs synchronize];
}

- (NSUInteger)count {
    return [self.passwordInfoData count];
}

- (NSString *)password:(NSUInteger)index {
    NSString *const string = [self.passwordStore loadFromKey:[self getKeyForItem:(self.passwordInfoData)[index]]];
    return string == nil ? @"" : string;
}

- (NSString *)getKeyForItem:(PasswordInfoItem *)item {
    return [@(item.uid) stringValue];
}

- (NSString *)label:(NSUInteger)index {
    id const o = (self.passwordInfoData)[index];
    return ((PasswordInfoItem *) o).label;
}

- (void)writeLabel:(NSString *)label forRow:(NSInteger)row {
    PasswordInfoItem *item = (self.passwordInfoData)[(NSUInteger) row];
    item.label = label;
}

- (void)writePassword:(NSString *)text forRow:(NSInteger)row {
    [self.passwordStore saveValue:text
                          withKey:[self getKeyForItem:(self.passwordInfoData)[(NSUInteger) row]]];
}

- (void)addNew:(NSString *)label password:(NSString *)password {
    NSInteger uid = [self allocateNewUid];
    PasswordInfoItem *newItem = [[PasswordInfoItem alloc] initWithUid:uid label:label];

    [self.passwordInfoData addObject:newItem];
    [self sortList];


    [self.passwordStore saveValue:password withKey:[self getKeyForItem:newItem]];
}

- (void)deleteAtIndex:(NSUInteger)index {
    PasswordInfoItem *const item = (self.passwordInfoData)[index];
    [self.passwordInfoData removeObjectAtIndex:index];
    [self.passwordStore deleteValueWithKey:[self getKeyForItem:item]];
    [self sortList];
}

- (void)sortList {
    [self.passwordInfoData sortUsingComparator:^(PasswordInfoItem *item1, PasswordInfoItem *item2) {
        return [item1.label.uppercaseString compare:item2.label.uppercaseString];
    }];
}

- (NSInteger)allocateNewUid {
    NSInteger highest = 0;
    for (PasswordInfoItem *passwordItem in self.passwordInfoData) {
        if (passwordItem.uid > highest) {
            highest = passwordItem.uid;
        }
    }

    return highest + 1;
}
@end