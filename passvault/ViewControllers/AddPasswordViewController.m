//
// Created by Neil on 26/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "AddPasswordViewController.h"
#import "TouchZone.h"


@implementation AddPasswordViewController {

}

NSUInteger const kMinPwdLength = 8;
NSUInteger const kMaxPwdLength = 64;
NSUInteger const kDefaultPwdLength = 32;

- (void)viewDidLoad {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.touchZone addGestureRecognizer:tapGestureRecognizer];

    self.passwordLengthSlider.value = [self getSliderValueFromLength:kDefaultPwdLength];
    [self lengthChanged];
}

- (void)tapped:(id)tapped {
    [self done];
}

- (IBAction)lengthChanged {
    NSUInteger length = [self getLengthFromSlider];
    self.passwordLengthText.text = [NSNumber numberWithInt:length].stringValue;

    if (self.password.text.length > length) {
        self.password.text = [self.password.text substringToIndex:length];
    }
}

- (NSUInteger const)getLengthFromSlider {
    return kMinPwdLength + (NSUInteger) roundf((kMaxPwdLength - kMinPwdLength) * self.passwordLengthSlider.value);
}

- (float)getSliderValueFromLength:(NSUInteger)length {
    return ((length - kMinPwdLength) / (float)(kMaxPwdLength - kMinPwdLength));
}

-(IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancelled{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end