//
// Created by Neil on 12/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TableViewController;

@protocol LongTapGestureRecogniserListener
- (void)longTapAtPoint:(CGPoint)point withIndexPath:(NSIndexPath *)indexPath;
- (void)longTapEnded;
@end

@interface LongTapGestureRecogniser : UILongPressGestureRecognizer <UIGestureRecognizerDelegate>
- (id)initWithTarget:(TableViewController<LongTapGestureRecogniserListener>*)listener;
@end