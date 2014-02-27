//
//  ViewController.h
//  passvault
//
//  Created by Neil on 26/02/2014.
//  Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

extern NSMutableDictionary *gDictionary;

@property(nonatomic, strong) IBOutlet UIBarButtonItem *addPasswordBtn;
@end