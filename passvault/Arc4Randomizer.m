//
// Created by Neil on 05/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "Arc4Randomizer.h"
#import "ViewController.h"


@implementation Arc4Randomizer {

}

- (NSUInteger)getNumber:(CGFloat)random {
    NSString *randomString = [NSString stringWithFormat:@"%.0f", random];
    arc4random_addrandom((unsigned char *) [randomString UTF8String], [randomString length]);

    return arc4random() % 10;
}

- (NSString *)getWord:(NSUInteger)length {
    NSArray *currentDict = [gDictionary objectForKey:[NSString stringWithFormat:@"%d", length]];
    NSUInteger index = arc4random() % [currentDict count];
    return [currentDict objectAtIndex:index];
}

- (NSUInteger)getPosition:(NSUInteger)availablePositions {
    return arc4random() % availablePositions;
}

- (CGFloat)getRandom {
    return ((CGFloat)arc4random()) / 0x100000000;
}


@end