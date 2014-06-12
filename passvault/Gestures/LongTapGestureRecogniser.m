//
// Created by Neil on 12/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

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