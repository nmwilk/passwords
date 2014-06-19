//
// Created by Neil on 19/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "JNKeychainPasswordStore.h"
#import "JNKeychain.h"


@implementation JNKeychainPasswordStore {

}
- (NSString *)loadFromKey:(NSString *)key {
    return [JNKeychain loadValueForKey:key];
}

- (void)saveValue:(NSString *)value withKey:(NSString *)key {
    [JNKeychain saveValue:value forKey:key];
}

- (void)deleteValueWithKey:(NSString *)key {
    [JNKeychain deleteValueForKey:key];
}

@end