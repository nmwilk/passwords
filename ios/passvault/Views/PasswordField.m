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


#import "PasswordField.h"
#import "PasswordGeneratorModel.h"
#import "Arc4Randomizer.h"
#import "Preferences.h"

@implementation PasswordField {
    PasswordGeneratorModel *passwordModel;
    NSUInteger lastLength;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        passwordModel = [[PasswordGeneratorModel alloc] initWithRandomizer:[Arc4Randomizer sharedInstance]];
    }

    return self;
}

- (void)refreshOptionsFromPreferences {
    passwordModel.capitalisationType = [Preferences sharedPrefs].capitaliseEveryWord ? PVCapitalisationTypeEveryWord : PVCapitalisationTypeRandom;
    passwordModel.includeSymbol = [Preferences sharedPrefs].includeSymbol;
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