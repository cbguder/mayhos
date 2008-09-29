//
//  RecentsController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import "RecentsController.h"

@implementation RecentsController

#pragma mark Initialization Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self == [super initWithCoder:aDecoder]) {
		refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh	target:self	action:@selector(refresh)];
		myURL = [[NSURL alloc] initWithString:@"http://sozluk.sourtimes.org/index.asp"];
		todayMode = YES;
	}
	
	return self;
}

- (void)dealloc {
	[refreshItem release];
	[super dealloc];
}

#pragma mark Other Methods

- (void)refresh {
	[self.navigationItem setRightBarButtonItem:activityItem animated:YES];
	[myConnection release];
	NSURLRequest *request =	[NSURLRequest requestWithURL:myURL];
    myConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
	[self.navigationItem setRightBarButtonItem:refreshItem animated:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[super connectionDidFinishLoading:connection];
	[self.navigationItem setRightBarButtonItem:refreshItem animated:YES];
}

@end
