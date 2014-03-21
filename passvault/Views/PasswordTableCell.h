//
// Created by Neil on 20/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PasswordTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *copiedToClipboard;

@property(nonatomic, readonly) BOOL animating;

- (void)animateCopyNotification;
@end