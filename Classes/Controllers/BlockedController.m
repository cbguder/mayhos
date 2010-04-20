//
//  BlockedController.m
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "BlockedController.h"

@implementation BlockedController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

@end
