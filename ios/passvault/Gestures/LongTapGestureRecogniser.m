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

#import "LongTapGestureRecogniser.h"
#import "TableViewController.h"


@interface LongTapGestureRecogniser ()
@property(nonatomic, weak) TableViewController <LongTapGestureRecogniserListener> *listener;
@end

@implementation LongTapGestureRecogniser {

}
- (id)initWithTarget:(TableViewController <LongTapGestureRecogniserListener> *)listener {
    self = [super initWithTarget:self action:@selector(onLongPress:)];

    self.listener = listener;

    self.minimumPressDuration = 1.0f;
    self.delegate = self;

    return self;
}

- (void)onLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [gestureRecognizer locationInView:self.listener.tableView];
        NSIndexPath *indexPath = [self.listener.tableView indexPathForRowAtPoint:touchPoint];

        if (indexPath != nil) {
            [self.listener longTapAtPoint:[gestureRecognizer locationInView:self.listener.tableView.superview] withIndexPath:indexPath];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.listener longTapEnded];
    }
}

@end