//
// Created by Neil on 26/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "AddPasswordViewController.h"
#import "TouchZone.h"
#import "PasswordField.h"


@implementation AddPasswordViewController {

}

NSUInteger const kMinPwdLength = 8;
NSUInteger const kMaxPwdLength = 32;
NSUInteger const kDefaultPwdLength = 16;

- (void)viewDidLoad {
    self.passwordLengthSlider.value = [self getSliderValueFromLength:kDefaultPwdLength];
    [self lengthChanged];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchZonePanned:)];
    [self.touchZone addGestureRecognizer:panGesture];
}

- (void)touchZonePanned:(UIPanGestureRecognizer *)panned {
    CGPoint pos = [panned locationInView:self.touchZone];

    CGFloat combined = pos.x * pos.y;

    [self.password addRandom:combined];
}

- (IBAction)lengthChanged {
    NSUInteger length = [self getLengthFromSlider];
    [self setPasswordLengthField:length];

    [self.password setLength:length];

    if (self.password.text.length > length) {
        self.password.text = [self.password.text substringToIndex:length];
    }
}

- (NSUInteger const)getLengthFromSlider {
    return kMinPwdLength + (NSUInteger) roundf((kMaxPwdLength - kMinPwdLength) * self.passwordLengthSlider.value);
}

- (float)getSliderValueFromLength:(NSUInteger)length {
    return ((length - kMinPwdLength) / (float) (kMaxPwdLength - kMinPwdLength));
}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 0) {
        return YES;
    }

    const NSUInteger passwordLength = [self getLengthFromSlider] + (string.length - range.length);

    // don't allow
    if (passwordLength < kMinPwdLength || passwordLength > kMaxPwdLength) {
        return NO;
    }

    [self setPasswordLengthField:passwordLength];
    self.passwordLengthSlider.value = [self getSliderValueFromLength:passwordLength];
    return YES;
}

- (void)setPasswordLengthField:(NSUInteger const)passwordLength {
    self.passwordLengthText.text = [NSString stringWithFormat:@"%d chars", passwordLength];
}

- (IBAction)cancelled {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end