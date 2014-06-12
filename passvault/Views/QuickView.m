//
// Created by Neil on 12/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "QuickView.h"


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

@end