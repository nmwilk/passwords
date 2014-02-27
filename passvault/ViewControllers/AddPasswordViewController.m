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
    self.passwordLengthSlider.value = [self getSliderValueFromLength:kDefaultPwdLength];
    [self lengthChanged];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchZonePanned:)];
    [self.touchZone addGestureRecognizer:panGesture];
}

- (void)touchZonePanned:(UIPanGestureRecognizer*)panned {
    CGPoint pos = [panned locationInView:self.touchZone];

    CGFloat combined = pos.x * pos.y;

    self.password.text = [NSString stringWithFormat:@"%.0f", combined];
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