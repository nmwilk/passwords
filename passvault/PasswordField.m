//
// Created by Neil on 27/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "PasswordField.h"
#import "ViewController.h"

int const kMinWordLength = 3;
int const kMaxWordLength = 9;

@implementation PasswordField {
    NSMutableString *password;
    NSUInteger maxLength;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }

    return self;
}

- (void)addRandom:(CGFloat)random {
    NSString *randomString = [NSString stringWithFormat:@"%.0f", random];
    arc4random_addrandom((unsigned char *) [randomString UTF8String], [randomString length]);

    int desiredLength = password == nil ? maxLength : maxLength - [password length];
    if (desiredLength >= kMaxWordLength) {
        desiredLength = kMaxWordLength;
    }

    NSString *word;
    NSLog(@"Looking for word of length %d", desiredLength);

    NSArray *currentDict = [gDictionary objectForKey:[NSString stringWithFormat:@"%d", desiredLength]];
    int index = arc4random() % [currentDict count];
    word = [currentDict objectAtIndex:index];

    if (password == nil) {
        password = [NSMutableString stringWithFormat:@"%@", word];
    } else {
        [password appendString:word];
    }

    if ([password length] > maxLength) {
        self.text = [password substringToIndex:maxLength];
    } else {
        self.text = password;
    }
}

- (void)setLength:(NSUInteger)length {
    maxLength = length;
    if (password != nil) {
        self.text = [password substringToIndex:maxLength];
    }
}

@end