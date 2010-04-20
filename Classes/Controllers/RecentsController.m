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
	self.refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																	 target:self
																	 action:@selector(refresh)];
	refreshItem.enabled = NO;
	self.navigationItem.leftBarButtonItem = refreshItem;
	[refreshItem release];

	self.URL = [API todayURL];
	[super viewDidLoad];
}

#pragma mark -
#pragma mark Eksi parser delegate

- (void)parserDidFinishParsing:(EksiParser *)parser {
	[super parserDidFinishParsing:parser];
	refreshItem.enabled = YES;
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	[super parser:parser didFailWithError:error];
	refreshItem.enabled = YES;
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
	refreshItem.enabled = NO;
	[self loadURL];
}

@end
