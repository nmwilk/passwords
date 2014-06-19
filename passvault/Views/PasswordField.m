//
// Created by Neil on 27/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "PasswordField.h"
#import "PasswordGeneratorModel.h"
#import "Arc4Randomizer.h"

@implementation PasswordField {
    PasswordGeneratorModel *passwordModel;
    NSUInteger lastLength;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        passwordModel = [[PasswordGeneratorModel alloc] initWithRandomizer:[[Arc4Randomizer alloc] init]];
    }

    return self;
}

- (void)addRandom:(CGFloat)random {
    [passwordModel addRandom:random];

    self.text = [passwordModel formPassword];

}

- (void)setLength:(NSUInteger)length {
    if (lastLength != length) {
        lastLength = length;

        [passwordModel setLength:length];

        self.text = [passwordModel formPassword];
    }
}
@end