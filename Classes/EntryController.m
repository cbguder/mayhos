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

- (id)initWithEntry:(EksiEntry *)entry {
    if (self = [super init]) {
		AuthorView *authorView = [[AuthorView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
		[authorView setAuthor:[entry author]];
		[authorView setDate:[entry dateString]];
		[self.view addSubview:authorView];
		[authorView release];

		UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(2, 55, 316, 300)];
		[contentView setFont:[UIFont systemFontOfSize:14]];
		[contentView setEditable:NO];
		[contentView setText:[entry content]];
		[self.view addSubview:contentView];
		[contentView release];
    }

    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
