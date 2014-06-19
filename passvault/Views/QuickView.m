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


#import "QuickView.h"
#import "PasswordTools.h"


@implementation QuickView {

}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
    }

    return self;
}

- (void)showWithText:(NSString *)password atPoint:(CGPoint)point {
    self.password.text = [PasswordTools getDisplayedPassword:password];

    if (self.hidden) {
        self.alpha = 0.0f;
        self.hidden = NO;
        self.center = CGPointMake(point.x, point.y);
        [self layer].transform = CATransform3DMakeScale(0.6f, 0.6f, 1.0f);
        [UIView animateWithDuration:0.5f
                              delay:0.0f
             usingSpringWithDamping:0.65f
              initialSpringVelocity:0.0f
                            options:UIViewAnimationOptionTransitionNone | UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
            self.alpha = 1.0f;
            [self layer].transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
        }
                         completion:^(BOOL finished) {
        }];
    }
}

-(void)hide {
    [UIView animateWithDuration:0.5f delay:0.0f
         usingSpringWithDamping:0.5f initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionTransitionNone | UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
        self.alpha = 0.0f;
    }
                     completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
@end