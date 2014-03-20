//
// Created by Neil on 20/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PasswordItem : NSObject<NSCoding>

@property(nonatomic, assign) NSUInteger uid;
@property(nonatomic, strong) NSString *label;

- (id)initWithUid:(NSUInteger)uid label:(NSString *)label;
@end