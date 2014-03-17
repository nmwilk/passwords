//
// Created by Neil on 05/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "PasswordModel.h"
#import "Randomizer.h"

NSInteger const kMinWordLength = 3;
NSInteger const kMaxWordLength = 7;

@interface PasswordModel ()
@property(nonatomic, strong) id <Randomizer> randomizer;
@end

@implementation PasswordModel {
    NSMutableArray *passwordItems;
    NSUInteger number;
    NSUInteger maxLength;
    CGFloat lastRandom;
    NSUInteger numberPosition;
    NSMutableString *password;
}

- (id)initWithRandomizer:(id <Randomizer>)randomizer {
    self = [super init];
    if (self) {
        self.randomizer = randomizer;
        passwordItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addRandom:(CGFloat)random {
    lastRandom = random;

    [passwordItems removeAllObjects];

    number = [self.randomizer getNumber:random];

    NSUInteger passwordLength = [self getLength];
    do {
        NSUInteger desiredLength = [self calcDesiredWordLength:passwordLength withRandom:[self.randomizer getRandom]];

        NSString *word;
        word = [self.randomizer getWord:desiredLength];

        [passwordItems addObject:word];

        passwordLength = [self getLength];
    } while (passwordLength < maxLength);

    numberPosition = [self.randomizer getPosition:[passwordItems count] + 1];
}

- (NSUInteger)calcDesiredWordLength:(NSUInteger)currentFormedLength withRandom:(CGFloat)random {

    // what's remaining?
    NSUInteger maxWordLength = maxLength - currentFormedLength;
    if (maxWordLength > kMaxWordLength) {
        maxWordLength = kMaxWordLength;
    }
    NSUInteger desiredLength = (NSUInteger) (kMinWordLength + roundf(random * ((maxWordLength - kMinWordLength) + 1)));
    if (desiredLength > maxWordLength) {
        desiredLength = maxWordLength;
    }

    // if it means there'll be less than the min word length left, reduce/increase the length.
    const NSInteger remaining = maxLength - (desiredLength + currentFormedLength);
    if (remaining > 0 && remaining < kMinWordLength) {
        NSInteger reduced = desiredLength - (kMinWordLength - remaining);
        if (reduced < kMinWordLength) {
            desiredLength += remaining;
        } else {
            desiredLength -= (kMinWordLength - remaining);
        }
    }
    return desiredLength;
}

- (NSString *)formPassword {
    password = [[NSMutableString alloc] init];
    if ([passwordItems count] > 0) {
        for (NSUInteger i = 0; i < [passwordItems count] + 1; i++) {
            if (i == numberPosition) {
                [password appendFormat:@"%d", number];
            }

            if (i < [passwordItems count]) {
                [password appendString:[passwordItems objectAtIndex:i]];
            }
        }
    }
    return password;
}

- (NSUInteger)getLength {
    NSUInteger length = 0;
    for (NSString *item in passwordItems) {
        length += [item length];
    }
    return length;
}

- (void)setLength:(NSUInteger)length {
    maxLength = length - 1;

    // recalculate.
    [passwordItems removeAllObjects];

    if (lastRandom > 0.0) {
        [self addRandom:lastRandom];
    }
}

@end