//
// Created by Neil on 27/02/2014.
// Copyright (c) 2014 MeasuredSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordField : UITextField

-(void)addRandom:(CGFloat)random;
-(void)setLength:(NSUInteger)length;
@end