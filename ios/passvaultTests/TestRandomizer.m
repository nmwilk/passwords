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

#import "TestRandomizer.h"


@implementation TestRandomizer {
    NSArray *testWords;
    NSUInteger testPosition;
}

- (id)init {
    self = [super init];
    if (self) {
        testWords = @[@"ABC", @"DEFG", @"HIJKL", @"MNOPQR", @"STUVWXY"];
        testPosition = 0;
    }

    return self;
}

- (NSUInteger)getNumber:(CGFloat)random {
    return ((NSUInteger) random) % 10;
}

- (NSString *)getWord:(NSUInteger)length {
    return testWords[length - 3];
}

- (NSUInteger)getPosition:(NSUInteger)count {
    return testPosition++ % count;
}

- (CGFloat)getRandom {
    return 1.0;
}


@end