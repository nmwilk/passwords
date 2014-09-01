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


#import <XCTest/XCTest.h>
#import "PasswordGeneratorModel.h"
#import "TestRandomizer.h"

@interface passwordModelTests : XCTestCase

@end

@implementation passwordModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPasswordModel {
    PasswordGeneratorModel *passwordModel = [[PasswordGeneratorModel alloc] initWithRandomizer:[[TestRandomizer alloc] init]];

    NSArray *expected = @[@"1Stuvwxy",
            @"HijklAbc2",
            @"Mnopqr3Abc",
            @"4StuvwxyAbc",
            @"StuvwxyDefg5",
            @"Stuvwxy6Hijkl",
            @"7StuvwxyMnopqr",
            @"StuvwxyStuvwxy8",
            @"9StuvwxyHijklAbc",
            @"StuvwxyMnopqr0Abc",
            @"1StuvwxyStuvwxyAbc",
            @"StuvwxyStuvwxy2Defg",
            @"3StuvwxyStuvwxyHijkl",
            @"StuvwxyStuvwxy4Mnopqr",
            @"5StuvwxyStuvwxyStuvwxy",
            @"6StuvwxyStuvwxyHijklAbc",
            @"StuvwxyStuvwxy7MnopqrAbc",
            @"StuvwxyStuvwxyStuvwxyAbc8",
            @"Stuvwxy9StuvwxyStuvwxyDefg",
            @"StuvwxyStuvwxyStuvwxy0Hijkl",
            @"1StuvwxyStuvwxyStuvwxyMnopqr",
            @"StuvwxyStuvwxy2StuvwxyStuvwxy",
            @"StuvwxyStuvwxy3StuvwxyHijklAbc",
            @"StuvwxyStuvwxyStuvwxyMnopqr4Abc"];

    for (NSUInteger j = 8; j < 32; j++) {
        [passwordModel setLength:j];

        [passwordModel addRandom:j - 7];

        NSString *result = [passwordModel formPassword];

        XCTAssertEqualObjects(expected[j - 8], result, @"");
    }
}


@end
