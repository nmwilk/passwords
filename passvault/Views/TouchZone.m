//
// Created by Neil on 26/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "TouchZone.h"


@implementation TouchZone {

}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];

        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

@end