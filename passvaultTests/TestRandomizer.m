//
// Created by Neil on 07/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "TestRandomizer.h"


@implementation TestRandomizer {
    NSArray *testWords;
    NSUInteger testPosition;
}

- (id)init {
    self = [super init];
    if (self) {
        testWords = [NSArray arrayWithObjects:@"ABC", @"DEFG", @"HIJKL", @"MNOPQR", @"STUVWXY", nil];
        testPosition = 0;
    }

    return self;
}

- (NSUInteger)getNumber:(CGFloat)random {
    return ((NSUInteger) random) % 10;
}

- (NSString *)getWord:(NSUInteger)length {
    return [testWords objectAtIndex:length - 3];
}

- (NSUInteger)getPosition:(NSUInteger)count {
    return testPosition++ % count;
}

- (CGFloat)getRandom {
    return 1.0;
}


@end