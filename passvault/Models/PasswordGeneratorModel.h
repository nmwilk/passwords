//
// Created by Neil on 05/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Randomizer;


@interface PasswordGeneratorModel : NSObject
- (id)initWithRandomizer:(id <Randomizer>)randomizer;

- (void)addRandom:(CGFloat)random1;

- (NSString *)formPassword;

- (void)setLength:(NSUInteger)length;
@end