//
// Created by Neil on 19/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "TestPasswordStore.h"


@implementation TestPasswordStore {

    NSMutableDictionary *passwords;
}

- (id)init {
    self = [super init];
    if (self) {
        passwords = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (NSString *)loadFromKey:(NSString *)key {
    return [passwords objectForKey:key];
}

- (void)saveValue:(NSString *)value withKey:(NSString *)key {
    [passwords setValue:value forKey:key];
}

- (void)deleteValueWithKey:(NSString *)key {
    [passwords removeObjectForKey:key];
}

@end