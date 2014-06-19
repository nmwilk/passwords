//
// Created by Neil on 19/06/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "AddButton.h"


@implementation AddButton {

}

- (id)initWithTarget:(id)target action:(SEL)action {
    UIImage *const image = [[UIImage imageNamed:@"add_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *customButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [customButtonView setImage:image forState:UIControlStateNormal];
    customButtonView.adjustsImageWhenDisabled = YES;
    [customButtonView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    self = [super initWithCustomView:customButtonView];

    return self;
}

@end