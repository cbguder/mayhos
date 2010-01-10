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
	[self.navigationItem setRightBarButtonItem:refreshItem];
	[refreshItem release];

	self.URL = [NSURL URLWithString:@"http://sozluk.sourtimes.org/index.asp"];
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

#pragma mark EksiParserDelegate Methods

- (void)parserDidFinishParsing:(EksiParser *)parser {
	[super parserDidFinishParsing:parser];
	[self.navigationItem setRightBarButtonItem:refreshItem];
	refreshItem.enabled = YES;
}

@end
