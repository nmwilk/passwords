//
// Created by Neil on 20/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PasswordInfoItem : NSObject<NSCoding>

@property(nonatomic, assign) NSInteger uid;
@property(nonatomic, strong) NSString *label;

- (id)initWithUid:(NSInteger)uid label:(NSString *)label;
@end