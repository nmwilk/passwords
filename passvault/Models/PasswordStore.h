//
// Created by Neil on 19/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PasswordStore <NSObject>

- (NSString *)loadFromKey:(NSString *)key;

- (void)saveValue:(NSString *)value withKey:(NSString *)key;

- (void)deleteValueWithKey:(NSString *)key;

@end