//
// Created by Neil on 27/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "PasswordField.h"
#import <CommonCrypto/CommonDigest.h>

@implementation PasswordField {
    NSMutableString *randomString;
    NSString *password;
    NSUInteger maxLength;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }

    return self;
}

- (void)addRandom:(CGFloat)random {

    if (randomString == nil) {
        randomString = [[NSMutableString alloc] initWithFormat:@"%.0f%.0f", random, [NSDate timeIntervalSinceReferenceDate]];
    } else {
        [randomString appendFormat:@"%@%.0f", password, random];
    }

    password = [self sha1:randomString];

    self.text = [password substringToIndex:maxLength];
}

- (void)setLength:(NSUInteger)length {
    maxLength = length;
    if (password != nil) {
        self.text = [password substringToIndex:maxLength];
    }
}


- (NSString *)sha1:(NSString *)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

@end