//
//  RecentsController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "RecentsController.h"

@implementation RecentsController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.refreshEnabled = YES;
	self.URL = [API todayURL];
	[super viewDidLoad];
}

@end
