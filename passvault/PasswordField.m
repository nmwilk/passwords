//
// Created by Neil on 27/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "PasswordField.h"
#import "ViewController.h"

int const kMinWordLength = 3;
int const kMaxWordLength = 6;

@implementation PasswordField {
    NSMutableArray *passwordItems;
    NSUInteger number;
    NSUInteger passwordLength;
    NSUInteger maxLength;
    CGFloat lastRandom;
    NSUInteger numberPosition;
    NSMutableString *password;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        passwordItems = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)addRandom:(CGFloat)random {
    lastRandom = random;

    if ([passwordItems count] > 0) {
        [passwordItems removeObjectAtIndex:0];
    }

    NSString *randomString = [NSString stringWithFormat:@"%.0f", random];
    arc4random_addrandom((unsigned char *) [randomString UTF8String], [randomString length]);

    number = arc4random() % 10;

    passwordLength = [self getLength];
    do {
        int desiredLength = maxLength - passwordLength;
        if (desiredLength >= kMaxWordLength) {
            desiredLength = kMaxWordLength;
        }

        NSString *word;
        NSLog(@"Looking for word of length %d", desiredLength);

        NSArray *currentDict = [gDictionary objectForKey:[NSString stringWithFormat:@"%d", desiredLength]];
        NSUInteger index = arc4random() % [currentDict count];
        word = [currentDict objectAtIndex:index];

        [passwordItems addObject:word];

        passwordLength = [self getLength];
    } while (passwordLength < maxLength);

    numberPosition = arc4random() % ([passwordItems count] + 1);

    self.text = [self formPassword];
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
    if (lastRandom > 0.0) {
        [self addRandom:lastRandom];
    }
}

@end