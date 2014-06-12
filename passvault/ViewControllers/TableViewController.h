//
//  TableViewController.h
//  passvault
//
//  Created by Neil on 26/02/2014.
//  Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LongTapGestureRecogniser.h"

@class TitleBanner;
@class QuickView;

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LongTapGestureRecogniserListener>

extern NSMutableDictionary *gDictionary;

@property(nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property(nonatomic, strong) IBOutlet TitleBanner *titleBanner;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet QuickView* quickView;

@end