//
// Created by Neil on 20/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

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