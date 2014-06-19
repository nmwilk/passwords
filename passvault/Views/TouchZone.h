//
// Created by Neil on 26/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TouchZone : UIView

@property(nonatomic, strong) IBOutlet UILabel *title;

- (void)randomisingDidStart:(CGFloat)normalised;

- (void)randomisingDidFinish;
@end