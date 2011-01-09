//
//  RecentsController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "RecentsController.h"

@implementation RecentsController

@synthesize refreshItem;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.URL = [API todayURL];

	self.refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	if ([links count] == 0) {
		refreshItem.enabled = NO;
	}
	self.navigationItem.leftBarButtonItem = refreshItem;
	[refreshItem release];

	[super viewDidLoad];
}

#pragma mark -
#pragma mark Eksi parser delegate

- (void)parserDidFinishParsing:(EksiParser *)aParser {
	[super parserDidFinishParsing:aParser];
	refreshItem.enabled = YES;
}

- (void)parser:(EksiParser *)aParser didFailWithError:(NSError *)error {
	[super parser:aParser didFailWithError:error];
	refreshItem.enabled = YES;
}

#pragma mark -
#pragma mark Refresh

- (void)refresh {
	self.refreshItem.enabled = NO;
	[self loadURL];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.refreshItem = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[refreshItem release];
	[super dealloc];
}

@end
