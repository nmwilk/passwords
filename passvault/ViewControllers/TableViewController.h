//
//  TableViewController.h
//  passvault
//
//  Created by Neil on 26/02/2014.
//  Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleBanner;

@interface TableViewController : UIViewController

extern NSMutableDictionary *gDictionary;

@property(nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property(nonatomic, strong) IBOutlet TitleBanner *titleBanner;

@end