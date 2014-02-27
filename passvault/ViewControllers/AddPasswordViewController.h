//
// Created by Neil on 26/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TouchZone;
@class PasswordField;

@interface AddPasswordViewController : UIViewController

@property (nonatomic, strong) IBOutlet TouchZone* touchZone;
@property (nonatomic, strong) IBOutlet UITextField* label;
@property (nonatomic, strong) IBOutlet PasswordField* password;
@property (nonatomic, strong) IBOutlet UILabel* passwordLengthText;
@property (nonatomic, strong) IBOutlet UISlider* passwordLengthSlider;

-(IBAction)lengthChanged;
-(IBAction)cancelled;
-(IBAction)done;

@end