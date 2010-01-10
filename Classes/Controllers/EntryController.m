//
//  EntryController.m
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "EntryController.h"
#import "AuthorView.h"
#import "EksiEntry.h"
#import "WebController.h"
#import "TitleController.h"
#import "EksiLinkController.h"
#import "NSURL+Query.h"

@interface EntryController (Private)
- (void)refreshViewContent;
@end

@implementation EntryController

@synthesize authorView, contentView;

- (id)initWithEksiTitle:(EksiTitle *)theTitle index:(NSUInteger)theIndex {
	if(self = [super initWithNibName:@"Entry" bundle:nil]) {
		eksiTitle = [theTitle retain];
		index = theIndex;
	}

	return self;
}

- (void)dealloc {
	[upDownControl release];
	[eksiTitle release];
	[super dealloc];
}

- (void)viewDidLoad {
	UIImage *up = [UIImage imageNamed:@"Up.png"];
	UIImage *down = [UIImage imageNamed:@"Down.png"];

	upDownControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:up, down, nil]];
	upDownControl.segmentedControlStyle = UISegmentedControlStyleBar;
	upDownControl.frame = CGRectMake(0, 0, 90, 30);
	upDownControl.momentary = YES;
	[upDownControl addTarget:self action:@selector(upDown:) forControlEvents:UIControlEventValueChanged];

	UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:upDownControl];
	[self.navigationItem setRightBarButtonItem:bar];
	[bar release];

	[self refreshViewContent];
}

- (void)refreshViewContent {
	NSUInteger entryCount = [eksiTitle.entries count];

	if(index < 0 || index >= entryCount) {
		return;
	}

	EksiEntry *entry = [eksiTitle.entries objectAtIndex:index];
	self.title = [NSString stringWithFormat:@"%d of %d", index+1, entryCount];

	if(upDownControl.numberOfSegments == 2) {
		[upDownControl setEnabled:(index != 0) forSegmentAtIndex:0];
		[upDownControl setEnabled:(index+1 != entryCount) forSegmentAtIndex:1];
	}

	if(authorView) {
		[authorView setAuthor:[entry author]];
		[authorView setDate:[entry dateString]];
	}

	if(contentView) {
		NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body{font-family:sans-serif;font-size:14px;}a{color:#236ed8;text-decoration:none;}a.internal{-webkit-touch-callout:none;}</style></head><body>%@</body></html>", entry.content];
		[contentView loadHTMLString:htmlString baseURL:nil];
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if(navigationType == UIWebViewNavigationTypeOther) {
		return YES;
	}

	if([request.URL.scheme isEqualToString:@"mayhos"]) {
		NSString *rest = [request.URL.absoluteString substringFromIndex:9];
		NSURL *realURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://sozluk.sourtimes.org/%@", rest]];

		if([rest hasPrefix:@"show.asp"]) {
			EksiTitle *title = [[EksiTitle alloc] init];
			[title setURL:realURL];

			TitleController *titleController = [[TitleController alloc] initWithEksiTitle:title];
			[self.navigationController pushViewController:titleController animated:YES];

			[titleController release];
			[title release];
		} else if([rest hasPrefix:@"index.asp"]) {
			NSString *kw = [[realURL queryDictionary] objectForKey:@"kw"];
			NSString *query = [kw stringByReplacingOccurrencesOfString:@"+" withString:@" "];

			EksiLinkController *linkController = [[EksiLinkController alloc] init];
			[linkController setTitle:query];
			[linkController setURL:realURL];
			[linkController loadURL];
			[self.navigationController pushViewController:linkController animated:YES];
			[linkController release];
		}
	} else {
		WebController *webController = [[WebController alloc] initWithURL:request.URL];
		[self.navigationController pushViewController:webController animated:YES];
		[webController release];
	}

	return NO;
}

- (void)upDown:(id)sender {
	UISegmentedControl *control = sender;

	switch(control.selectedSegmentIndex) {
		case 0:
			index--;
			break;
		case 1:
			index++;
			break;
	}

	[self refreshViewContent];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
