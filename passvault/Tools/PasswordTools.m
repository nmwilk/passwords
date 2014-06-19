//
// Created by Neil on 19/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

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