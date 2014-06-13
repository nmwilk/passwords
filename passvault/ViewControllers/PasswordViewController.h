//
// Created by Neil on 18/03/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

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