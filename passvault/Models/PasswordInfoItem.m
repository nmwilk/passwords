//
// Created by Neil on 20/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

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