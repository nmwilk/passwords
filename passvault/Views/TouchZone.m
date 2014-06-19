//
// Created by Neil on 26/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "TouchZone.h"


@implementation TouchZone {

    CGFloat textMaxAlpha;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        textMaxAlpha = self.title.alpha;
    }
    
    return self;
}

-(void)randomisingDidStart:(CGFloat)normalised {
    self.title.alpha = (CGFloat) (textMaxAlpha * (normalised > 1.0 ? 1.0 : normalised));
}

-(void)randomisingDidFinish {
    self.title.alpha = textMaxAlpha;
}

@end