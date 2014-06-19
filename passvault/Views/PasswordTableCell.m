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


#import "PasswordTableCell.h"


static const float scale = 1.2;

@implementation PasswordTableCell {

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)animateCopyNotification {
    self.copiedToClipboard.hidden = NO;
    self.copiedToClipboard.alpha = 1.0;

    _animating = YES;

    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone)
                     animations:^{
                         CATransform3D tr = CATransform3DMakeScale(scale, scale, 1);
                         self.copiedToClipboard.layer.anchorPoint = CGPointMake(0.5, 0.5);
                         self.copiedToClipboard.layer.transform = tr;
                         self.copiedToClipboard.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.copiedToClipboard.hidden = YES;
                         self.copiedToClipboard.alpha = 1.0;
                         self.copiedToClipboard.layer.transform = CATransform3DMakeScale(1, 1, 1);
                         _animating = NO;
                     }];
}
@end