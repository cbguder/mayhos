//
//  EntryController.m
//  Eksi Sozluk
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "EntryController.h"
#import "AuthorView.h"
#import "EksiEntry.h"

@implementation EntryController

@synthesize entry;

- (id)initWithEntry:(EksiEntry *)anEntry {
    if(self = [super init]) {
		[self setEntry:anEntry];
    }

    return self;
}

- (void)loadView {
	[super loadView];

	AuthorView *authorView = [[AuthorView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
	[authorView setAuthor:[entry author]];
	[authorView setDate:[entry dateString]];
	[self.view addSubview:authorView];
	[authorView release];

	UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(2, 55, 316, 312)];
	[contentView setFont:[UIFont systemFontOfSize:14]];
	[contentView setEditable:NO];
	[contentView setText:[entry content]];
	[self.view addSubview:contentView];
	[contentView release];
}

- (void)dealloc {
	[entry release];
    [super dealloc];
}

@end
