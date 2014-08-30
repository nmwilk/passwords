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


@class PasswordList;
@class TouchZone;
@class PasswordField;

enum PageType {
    PageTypeEdit,
    PageTypeNew
};

typedef enum PageType PageType;

@interface PasswordViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet TouchZone *touchZone;
@property(nonatomic, strong) IBOutlet UILabel *pageTitle;
@property(nonatomic, strong) IBOutlet UILabel *passwordLengthText;
@property(nonatomic, strong) IBOutlet UIButton *doneButton;

@property(nonatomic, strong) IBOutlet UISlider *passwordLengthSlider;
@property(nonatomic, strong) IBOutlet UITextField *labelField;
@property(nonatomic, strong) IBOutlet PasswordField *passwordField;
@property(nonatomic, strong) IBOutlet UIView *randomizerSection;
@property(nonatomic, strong) PasswordList *list;

- (void)configureForNewPasswordWithPasswordList:(PasswordList *)list;

- (void)configureForEditPasswordWithPasswordList:(PasswordList *)list row:(NSInteger)row;

- (IBAction)sliderLengthChanged;

- (IBAction)cancelled;

- (IBAction)done;

@end