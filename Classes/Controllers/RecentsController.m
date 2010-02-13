//
//  RecentsController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "RecentsController.h"

@implementation RecentsController

@synthesize refreshItem;

#pragma mark Initialization Methods

- (void)viewDidLoad {
	[super viewDidLoad];

	self.refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																	 target:self
																	 action:@selector(refresh)];
	[self.navigationItem setLeftBarButtonItem:refreshItem];
	[refreshItem release];

	self.URL = [NSURL URLWithString:[kSozlukURL stringByAppendingString:@"index.asp?a=td"]];
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

	if([titles count] == 0) {
		[self refresh];
	}
}

#pragma mark PagedController Methods

- (void)loadPage:(NSUInteger)page {
	self.URL = [NSURL URLWithString:[kSozlukURL stringByAppendingFormat:@"index.asp?a=td&p=%d", page]];
	[self loadURL];
}

#pragma mark EksiParserDelegate Methods

- (void)parserDidFinishParsing:(EksiParser *)parser {
	[super parserDidFinishParsing:parser];
	self.navigationItem.leftBarButtonItem = refreshItem;
	refreshItem.enabled = YES;

	pages = parser.pages;
	currentPage = parser.currentPage;
	[super finishedLoadingPage];
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	[super parser:parser didFailWithError:error];
	self.navigationItem.leftBarButtonItem = refreshItem;
	refreshItem.enabled = YES;

	pages = parser.pages;
	currentPage = parser.currentPage;
	[super finishedLoadingPage];
}

@end
