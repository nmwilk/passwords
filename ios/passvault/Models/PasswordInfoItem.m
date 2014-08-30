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


#import "PasswordInfoItem.h"


#define kKeyUid @"UID"
#define kKeyLabel @"LABEL"

@implementation PasswordInfoItem {

}
- (id)initWithUid:(NSInteger)uid label:(NSString *)label {
    self = [super init];

    if (self) {
        self.uid = uid;
        self.label = label;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    if (self != nil) {
        self.uid = [decoder decodeIntegerForKey:kKeyUid];
        self.label = [decoder decodeObjectForKey:kKeyLabel];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.uid forKey:kKeyUid];
    [encoder encodeObject:self.label forKey:kKeyLabel];
}

@end