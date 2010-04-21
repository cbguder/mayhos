//
//  RandomController.m
//  mayhos
//
//  Created by Can Berk Güder on 21/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RandomController.h"

@implementation RandomController

- (void)viewDidLoad {
	self.URL = [API randomURL];
	[super viewDidLoad];
}

@end
