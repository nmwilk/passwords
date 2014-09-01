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


#import <Foundation/Foundation.h>

@protocol PasswordStore;

@interface PasswordList : NSObject

@property(nonatomic, strong) NSMutableArray *passwordInfoData;
@property(nonatomic, assign) NSInteger passwordLength;

- (id)initWithPasswordStore:(id<PasswordStore>)passwordStore;

- (void)savePasswordsInfos;

- (NSUInteger)count;

- (NSString *)password:(NSUInteger)needle;

- (NSString *)label:(NSUInteger)index1;

- (void)writeLabel:(NSString *)label forRow:(NSInteger)row;

- (void)writePassword:(NSString *)text forRow:(NSInteger)row;

- (void)addNew:(NSString *)label password:(NSString *)password;

- (void)deleteAtIndex:(NSUInteger)index;
@end