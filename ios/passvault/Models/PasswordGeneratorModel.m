// Copyright 2014 Neil Wilkinson
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#import "PasswordGeneratorModel.h"
#import "Randomizer.h"

static const NSInteger kMinWordLength = 3;
static const NSInteger kMaxWordLength = 7;
static const NSString *kSymbols = @"\"!$%&'()*+,-./:;<=>?@[\\]^_`";

@interface PasswordGeneratorModel ()
@property(nonatomic, strong) id <Randomizer> randomizer;
@end

@implementation PasswordGeneratorModel {
    NSMutableArray *passwordItems;
    NSUInteger number;
    NSUInteger maxLength;
    CGFloat lastRandom;
    NSUInteger numberPosition;
    NSMutableString *password;
    NSUInteger totalLength;
    NSUInteger symbolPosition;
    unichar symbol;
    NSUInteger reservedSpace;
}

- (id)initWithRandomizer:(id <Randomizer>)randomizer {
    self = [super init];
    if (self) {
        self.randomizer = randomizer;
        passwordItems = [[NSMutableArray alloc] init];

        self.capitalisationType = PVCapitalisationTypeEveryWord;
        reservedSpace = 1;
    }
    return self;
}

- (void)setIncludeSymbol:(BOOL)includeSymbol {
    _includeSymbol = includeSymbol;

    reservedSpace = _includeSymbol ? 2 : 1;
    [self setLength:totalLength];
}

- (void)addRandom:(CGFloat)random {
    lastRandom = random;

    [passwordItems removeAllObjects];

    number = [self.randomizer getNumber:random];

    if (self.includeSymbol) {
        symbol = [kSymbols characterAtIndex:[self.randomizer getPosition:kSymbols.length]];
    }

    NSUInteger passwordLength = [self getLength];
    do {
        NSUInteger desiredLength = [self calcDesiredWordLength:passwordLength withRandom:[self.randomizer getRandom]];

        NSString *word = [self capitaliseWord:[self.randomizer getWord:desiredLength] withRandom:[self.randomizer getBoolean]];

        [passwordItems addObject:word];

        passwordLength = [self getLength];
    } while (passwordLength < maxLength);

    numberPosition = [self.randomizer getPosition:[passwordItems count] + reservedSpace];

    if (self.includeSymbol) {
        symbolPosition = [self.randomizer getPosition:[passwordItems count] + reservedSpace];
    }
}

- (NSString *)capitaliseWord:(NSString *)word withRandom:(BOOL)capitaliseWord {
    NSString *formattedWord;

    if (self.capitalisationType == PVCapitalisationTypeEveryWord || capitaliseWord) {
        formattedWord = word.capitalizedString;
    } else {
        formattedWord = word.lowercaseString;
    }

    return formattedWord;
}

- (NSUInteger)calcDesiredWordLength:(NSUInteger)currentFormedLength withRandom:(CGFloat)random {

    // what's remaining?
    NSUInteger maxWordLength = maxLength - currentFormedLength;
    if (maxWordLength > kMaxWordLength) {
        maxWordLength = kMaxWordLength;
    }
    NSUInteger desiredLength = (NSUInteger) (kMinWordLength + roundf(random * ((maxWordLength - kMinWordLength) + reservedSpace)));
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
        for (NSUInteger i = 0; i < [passwordItems count] + reservedSpace; i++) {
            if (i == numberPosition) {
                [password appendFormat:@"%d", (int)number];
            }

            if (self.includeSymbol && i == symbolPosition) {
                [password appendFormat:@"%c", symbol];
            }

            if (i < [passwordItems count]) {
                [password appendString:passwordItems[i]];
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
    totalLength = length;

    maxLength = length - reservedSpace;

    // recalculate.
    [passwordItems removeAllObjects];

    if (lastRandom > 0.0) {
        [self addRandom:lastRandom];
    }
}

@end