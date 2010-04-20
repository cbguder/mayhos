//
//  YesterdayController.m
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "YesterdayController.h"

@implementation YesterdayController

- (void)viewDidLoad {
	self.URL = [API yesterdayURL];
	[super viewDidLoad];
}

@end
