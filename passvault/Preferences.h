//
// Created by Neil on 13/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Preferences : NSObject
+ (Preferences *)sharedPrefs;

- (BOOL)obscurePasswords;

- (void)setObscurePasswords:(BOOL)obscurePasswords;
@end