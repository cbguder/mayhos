//
//  RefreshedController.m
//  mayhos
//
//  Created by Can Berk Güder on 25/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RefreshedController.h"

@implementation RefreshedController

@synthesize refreshItem, refreshItemEnabled;

- (void)setRefreshItemEnabled:(BOOL)enabled {
	refreshItemEnabled = enabled;
	self.refreshItem.enabled = enabled;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																	 target:self
																	 action:@selector(refresh)];
	self.refreshItemEnabled = self.refreshItemEnabled;
	self.navigationItem.leftBarButtonItem = refreshItem;
	[refreshItem release];

	[super viewDidLoad];
}

#pragma mark -
#pragma mark Eksi parser delegate

- (void)parserDidFinishParsing:(EksiParser *)aParser {
	[super parserDidFinishParsing:aParser];
	self.refreshItemEnabled = YES;
}

- (void)parser:(EksiParser *)aParser didFailWithError:(NSError *)error {
	[super parser:aParser didFailWithError:error];
	self.refreshItemEnabled = YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[refreshItem release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.refreshItem = nil;
	[super viewDidUnload];
}

#pragma mark -

- (void)refresh {
	self.refreshItemEnabled = NO;
	[self loadURL];
}

@end
