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
#import "TableViewController.h"


@implementation Arc4Randomizer {

}

- (NSUInteger)getNumber:(CGFloat)random {
    NSString *randomString = [NSString stringWithFormat:@"%.0f", random];
    arc4random_addrandom((unsigned char *) [randomString UTF8String], (int)[randomString length]);

    return arc4random() % 10;
}

- (NSString *)getWord:(NSUInteger)length {
    NSArray *currentDict = [gDictionary objectForKey:[NSString stringWithFormat:@"%d", (int)length]];
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