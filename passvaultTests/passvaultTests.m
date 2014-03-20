//
//  passvaultTests.m
//  passvaultTests
//
//  Created by Neil on 26/02/2014.
//  Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PasswordGeneratorModel.h"
#import "TestRandomizer.h"

@interface passvaultTests : XCTestCase

@end

@implementation passvaultTests

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

    NSArray *expected = @[@"1STUVWXY",
            @"HIJKLABC2",
            @"MNOPQR3ABC",
            @"4STUVWXYABC",
            @"STUVWXYDEFG5",
            @"STUVWXY6HIJKL",
            @"7STUVWXYMNOPQR",
            @"STUVWXYSTUVWXY8",
            @"9STUVWXYHIJKLABC",
            @"STUVWXYMNOPQR0ABC",
            @"1STUVWXYSTUVWXYABC",
            @"STUVWXYSTUVWXY2DEFG",
            @"3STUVWXYSTUVWXYHIJKL",
            @"STUVWXYSTUVWXY4MNOPQR",
            @"5STUVWXYSTUVWXYSTUVWXY",
            @"6STUVWXYSTUVWXYHIJKLABC",
            @"STUVWXYSTUVWXY7MNOPQRABC",
            @"STUVWXYSTUVWXYSTUVWXYABC8",
            @"STUVWXY9STUVWXYSTUVWXYDEFG",
            @"STUVWXYSTUVWXYSTUVWXY0HIJKL",
            @"1STUVWXYSTUVWXYSTUVWXYMNOPQR",
            @"STUVWXYSTUVWXY2STUVWXYSTUVWXY",
            @"STUVWXYSTUVWXY3STUVWXYHIJKLABC",
            @"STUVWXYSTUVWXYSTUVWXYMNOPQR4ABC"];

    for (NSUInteger j = 8; j < 32; j++) {
        [passwordModel setLength:j];

        [passwordModel addRandom:j - 7];

        NSString *result = [passwordModel formPassword];

        XCTAssertEqualObjects([expected objectAtIndex:j-8], result, @"");
    }
}


@end
