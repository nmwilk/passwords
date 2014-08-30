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