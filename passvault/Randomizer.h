//
// Created by Neil on 05/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Randomizer <NSObject>
- (NSUInteger)getNumber:(CGFloat)random;

- (NSString *)getWord:(NSUInteger)length;

- (NSUInteger)getPosition:(NSUInteger)count;
@end