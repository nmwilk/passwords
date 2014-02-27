//
//  ViewController.m
//  passvault
//
//  Created by Neil on 26/02/2014.
//  Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

NSMutableDictionary *gDictionary;
NSArray *wordLengths;

@implementation ViewController {
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadDictionary];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadDictionary];
    }
    return self;
}

- (void)loadDictionary {
    wordLengths = [NSArray arrayWithObjects:@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    gDictionary = [[NSMutableDictionary alloc] init];

    for(NSString *wordLength in wordLengths) {

        NSString *filePath = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"enable1_%@", wordLength] ofType:@"txt"];
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSString* delimiter = @"\n";
        NSArray *fileAsArray = [fileContent componentsSeparatedByString:delimiter];
        [gDictionary setObject:fileAsArray forKey:wordLength];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end