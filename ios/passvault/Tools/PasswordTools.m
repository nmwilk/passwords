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

#import "PasswordTools.h"
#import "Preferences.h"


@implementation PasswordTools {

}

+ (NSString *)getDisplayedPassword:(NSString *const)string {
    if ([Preferences sharedPrefs].obscurePasswords) {

        NSMutableString *copy = [string mutableCopy];

        NSRange rangeToReplace;
        if (string.length < 5) {
            rangeToReplace = NSMakeRange(0, string.length);
        } else if (string.length < 7) {
            rangeToReplace = NSMakeRange(1, string.length - 2);
        } else {
            rangeToReplace = NSMakeRange(2, string.length - 4);
        }

        [copy replaceCharactersInRange:rangeToReplace withString:[@"" stringByPaddingToLength:rangeToReplace.length
                                                                                   withString:@"●"
                                                                              startingAtIndex:0]];

        return copy;
    } else {
        return string;
    }
}
@end