//
//  RecentsController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "RecentsController.h"

@implementation RecentsController

#pragma mark Initialization Methods

- (void)viewDidLoad {
	[super viewDidLoad];

	refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																target:self
																action:@selector(refresh)];
	[self.navigationItem setRightBarButtonItem:refreshItem];

	self.myURL = [NSURL URLWithString:@"http://sozluk.sourtimes.org/index.asp"];
}

- (void)dealloc {
	[refreshItem release];
	[super dealloc];
}

#pragma mark Other Methods

- (void)refresh {
	refreshItem.enabled = NO;
	[self loadURL];
}

#pragma mark UIViewController Methods

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([stories count] == 0) {
		[self refresh];
	}
}

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[super connection:connection didFailWithError:error];
	[self.navigationItem setRightBarButtonItem:refreshItem];
	refreshItem.enabled = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[super connectionDidFinishLoading:connection];
	[self.navigationItem setRightBarButtonItem:refreshItem];
	refreshItem.enabled = YES;
}

@end
