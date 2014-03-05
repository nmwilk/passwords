//
// Created by Neil on 05/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "PasswordModel.h"
#import "Randomizer.h"

int const kMinWordLength = 3;
int const kMaxWordLength = 6;

@interface PasswordModel ()
@property(nonatomic, strong) id <Randomizer> randomizer;
@end

@implementation PasswordModel {
    NSMutableArray *passwordItems;
    NSUInteger number;
    NSUInteger passwordLength;
    NSUInteger maxLength;
    CGFloat lastRandom;
    NSUInteger numberPosition;
    NSMutableString *password;
}

-(id)initWithRandomizer:(id<Randomizer>)randomizer {
    self = [super init];
    if (self) {
        self.randomizer = randomizer;
        passwordItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addRandom:(CGFloat)random {
    lastRandom = random;

    if ([passwordItems count] > 0) {
        [passwordItems removeObjectAtIndex:0];
    }

    number = [self.randomizer getNumber:random];

    passwordLength = [self getLength];
    do {
        NSUInteger desiredLength = maxLength - passwordLength;
        if (desiredLength >= kMaxWordLength) {
            desiredLength = kMaxWordLength;
        }

        const NSUInteger remaining = maxLength - desiredLength;
        if (remaining > 0 && remaining < kMinWordLength) {
            desiredLength -= (kMinWordLength - remaining);
        }
        
        NSString *word;
        NSLog(@"Looking for word of length %d", desiredLength);
        word = [self.randomizer getWord:desiredLength];

        [passwordItems addObject:word];

        passwordLength = [self getLength];
    } while (passwordLength < maxLength);

    numberPosition = [self.randomizer getPosition:[passwordItems count] + 1];
}

- (NSString *)formPassword {
    password = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < [passwordItems count] + 1; i++) {
        if (i == numberPosition) {
            [password appendFormat:@"%d", number];
        }

        if (i < [passwordItems count]) {
            [password appendString:[passwordItems objectAtIndex:i]];
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