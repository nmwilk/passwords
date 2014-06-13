//
// Created by Neil on 18/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "PasswordViewController.h"
#import "TouchZone.h"
#import "PasswordList.h"
#import "PasswordField.h"

@interface PasswordViewController ()
@property(nonatomic) NSInteger editedItem;
@property(nonatomic, copy) NSString *labelText;
@property(nonatomic, copy) NSString *passwordText;
@property(nonatomic) PageType pageType;
@end

@implementation PasswordViewController {
}

NSUInteger const kMinPwdLength = 8;
NSUInteger const kMaxPwdLength = 32;
NSUInteger const kDefaultPwdLength = 16;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.passwordLengthSlider.value = [self getSliderValueFromLength:kDefaultPwdLength];

    if (self.pageType == PageTypeEdit) {
        self.pageTitle.text = NSLocalizedString(@"Edit Password", @"");
        self.randomizerSection.hidden = YES;

        self.labelField.text = self.labelText;
        self.passwordField.text = self.passwordText;
        self.passwordText = nil;
    } else if (self.pageType == PageTypeNew) {
        self.pageTitle.text = NSLocalizedString(@"New Password", @"");
        self.randomizerSection.hidden = NO;

        [self lengthChanged];
    }

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(touchZonePanned:)];
    [self.touchZone addGestureRecognizer:panGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.pageType == PageTypeNew) {
        [self.labelField becomeFirstResponder];
    }
}

- (void)touchZonePanned:(UIPanGestureRecognizer *)panned {
    [self removeFocusFromTextFields];

    CGPoint pos = [panned locationInView:self.touchZone];

    CGFloat combined = pos.x * pos.y;

    [self.passwordField addRandom:combined];
}

- (void)removeFocusFromTextFields {
    if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    } else if ([self.labelField isFirstResponder]) {
        [self.labelField resignFirstResponder];
    }
}

- (void)configureForNewPasswordWithPasswordList:(PasswordList *)list {
    self.pageType = PageTypeNew;

    self.list = list;
}

- (void)configureForEditPasswordWithPasswordList:(PasswordList *)list
                                             row:(NSInteger)row {
    self.pageType = PageTypeEdit;

    self.list = list;

    self.editedItem = row;
    self.labelText = [list label:(NSUInteger) row];
    self.passwordText = [list password:(NSUInteger) row];
}

- (IBAction)sliderLengthChanged {
    [self removeFocusFromTextFields];
    [self lengthChanged];
}

-(void)lengthChanged {
    NSUInteger length = [self getLengthFromSlider];
    [self setPasswordLengthField:length];

    [self.passwordField setLength:length];

    if (self.passwordField.text.length > length) {
        self.passwordField.text = [self.passwordField.text substringToIndex:length];
    }
}

- (NSUInteger const)getLengthFromSlider {
    return kMinPwdLength + (NSUInteger) roundf((kMaxPwdLength - kMinPwdLength) * self.passwordLengthSlider.value);
}

- (float)getSliderValueFromLength:(NSUInteger)length {
    return ((length - kMinPwdLength) / (float) (kMaxPwdLength - kMinPwdLength));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordField) {
        [textField resignFirstResponder];
    } else if (textField == self.labelField) {
        [self.passwordField becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {

    if (textField == self.passwordField) {
        if (range.length == 0) {
            if (string.length == 1) {
                [self hideRandomizer];
            }

            return YES;
        }

        if (self.randomizerSection.hidden) {
            if (textField.text.length - range.length == 0) {
                [self showRandomizer];
            }
        }

        else {
            const NSUInteger passwordLength = [self getLengthFromSlider] + (string.length - range.length);
            // don't allow
            if (passwordLength < kMinPwdLength || passwordLength > kMaxPwdLength) {
                return NO;
            }

            [self setPasswordLengthField:passwordLength];
            self.passwordLengthSlider.value = [self getSliderValueFromLength:passwordLength];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.passwordField) {
        if (self.randomizerSection.hidden) {
            [self showRandomizer];
        }
    }
    return YES;
}


- (void)showRandomizer {
    self.randomizerSection.alpha = 0.0;
    self.randomizerSection.hidden = NO;
    self.randomizerSection.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                     animations:^{
        self.randomizerSection.alpha = 1.0;
        self.randomizerSection.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    [self lengthChanged];
}

- (void)hideRandomizer {
    self.randomizerSection.alpha = 1.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                     animations:^{
        self.randomizerSection.alpha = 0.0f;
    } completion:(void (^)(BOOL)) ^{
        self.randomizerSection.hidden = YES;
    }];
}

- (void)setPasswordLengthField:(NSUInteger const)passwordLength {
    self.passwordLengthText.text = [NSString stringWithFormat:@"%d chars", (int) passwordLength];
}

- (IBAction)done {
    if (self.pageType == PageTypeEdit) {
        [self.list writeLabel:self.labelField.text forRow:self.editedItem];
        [self.list writePassword:self.passwordField.text forRow:self.editedItem];
        [self.list savePasswordsInfos];
    } else if (self.pageType == PageTypeNew) {
        if (self.labelField.text.length > 0 && self.passwordField.text.length > 0) {
            [self.list addNew:self.labelField.text password:self.passwordField.text];
            [self.list savePasswordsInfos];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end