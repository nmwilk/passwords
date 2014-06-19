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
#import "PasswordList.h"
#import "TestPasswordStore.h"

@interface passwordListTests : XCTestCase

@end

@implementation passwordListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPasswordStoreAdd {
    PasswordList *passwordList = [[PasswordList alloc] initWithPasswordStore:[[TestPasswordStore alloc] init]];

    XCTAssertTrue([passwordList count] == 1);
    XCTAssertEqualObjects(@"iTunes", [passwordList label:0]);
    XCTAssertEqualObjects(@"", [passwordList password:0]);

    [passwordList addNew:@"A Label1" password:@"Password1"];
    XCTAssertEqualObjects(@"A Label1", [passwordList label:0]);
    XCTAssertEqualObjects(@"Password1", [passwordList password:0]);

    XCTAssertTrue([passwordList count] == 2);
}

- (void)testPasswordStoreDelete {
    PasswordList *passwordList = [[PasswordList alloc] initWithPasswordStore:[[TestPasswordStore alloc] init]];

    [passwordList addNew:@"A Label1" password:@"Password1"];
    XCTAssertEqualObjects(@"A Label1", [passwordList label:0]);
    XCTAssertEqualObjects(@"Password1", [passwordList password:0]);

    XCTAssertTrue([passwordList count] == 2);

    [passwordList deleteAtIndex:0];
    XCTAssertEqualObjects(@"iTunes", [passwordList label:0]);
    XCTAssertEqualObjects(@"", [passwordList password:0]);
    XCTAssertTrue([passwordList count] == 1);
}

-(void)testPasswordStoreEdit {
    PasswordList *passwordList = [[PasswordList alloc] initWithPasswordStore:[[TestPasswordStore alloc] init]];

    XCTAssertEqualObjects(@"iTunes", [passwordList label:0]);
    XCTAssertEqualObjects(@"", [passwordList password:0]);

    [passwordList writePassword:@"NewiTunesPwd" forRow:0];
    XCTAssertEqualObjects(@"NewiTunesPwd", [passwordList password:0]);
}


@end
