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


#import "Arc4Randomizer.h"

@implementation Arc4Randomizer {
    NSArray *wordLengths;
    NSMutableDictionary *dictionary;
}


- (id)init {
    self = [super init];

    wordLengths = @[@"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    dictionary = [[NSMutableDictionary alloc] init];

    for (NSString *wordLength in wordLengths) {

        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"enable1_%@",
                                                                                               wordLength]
                                                             ofType:@"txt"];
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding
                                                             error:nil];
        NSString *delimiter = @"\n";
        NSArray *fileAsArray = [fileContent componentsSeparatedByString:delimiter];
        dictionary[wordLength] = fileAsArray;
    }

    return self;
}

- (NSUInteger)getNumber:(CGFloat)random {
    NSString *randomString = [NSString stringWithFormat:@"%.0f", random];
    arc4random_addrandom((unsigned char *) [randomString UTF8String], (int) [randomString length]);

    return arc4random() % 10;
}

+ (Arc4Randomizer *)sharedInstance {
    static Arc4Randomizer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (NSString *)getWord:(NSUInteger)length {
    NSArray *currentDict = dictionary[[NSString stringWithFormat:@"%d", (int) length]];
    NSUInteger index = arc4random() % [currentDict count];
    return currentDict[index];
}

- (NSUInteger)getPosition:(NSUInteger)availablePositions {
    return arc4random() % availablePositions;
}

- (CGFloat)getRandom {
    return ((CGFloat) arc4random()) / 0x100000000;
}


@end