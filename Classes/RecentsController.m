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

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self == [super initWithCoder:aDecoder]) {
		refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh	target:self	action:@selector(refresh)];
		[self.navigationItem setRightBarButtonItem:refreshItem];

		myURL = [[NSURL alloc] initWithString:@"http://sozluk.sourtimes.org/index.asp"];
	}
	
	return self;
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

#pragma mark NSXMLParserDelegate Methods

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[self.navigationItem setRightBarButtonItem:refreshItem];
	refreshItem.enabled = YES;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[self.navigationItem setRightBarButtonItem:refreshItem];
	refreshItem.enabled = YES;
}


@end
