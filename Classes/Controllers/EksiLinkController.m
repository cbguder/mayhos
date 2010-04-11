//
//  EksiLinkController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 28/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiLinkController.h"
#import "LeftFrameParser.h"
#import "NSURL+Query.h"

@implementation EksiLinkController

@synthesize titles, refreshItem, refreshEnabled, URL;

#pragma mark -
#pragma mark Initialization

- (id)init {
	if(self = [self initWithCoder:nil]) {
		self.hidesBottomBarWhenPushed = YES;
	}

	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		self.refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																		 target:self
																		 action:@selector(refresh)];
		[refreshItem release];
	}

	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	if(refreshEnabled) {
		[self.navigationItem setLeftBarButtonItem:refreshItem];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([titles count] == 0 && URL != nil) {
		[self refresh];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *linkCellIdentifier = @"titleCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:linkCellIdentifier];

	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:linkCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	cell.textLabel.text = [[titles objectAtIndex:[indexPath row]] title];

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *title = [[TitleController alloc] initWithEksiTitle:[titles objectAtIndex:[indexPath row]]];
	[self.navigationController pushViewController:title animated:YES];
	[title release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[refreshItem release];
	[titles release];
	[URL release];
	[super dealloc];
}

#pragma mark -
#pragma mark Parser delegate

- (void)parserDidFinishParsing:(EksiParser *)parser {
	self.titles = [NSMutableArray arrayWithArray:parser.results];

	[self.tableView reloadData];
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	[self.navigationItem setRightBarButtonItem:nil];

	if(refreshEnabled) {
		[self.navigationItem setLeftBarButtonItem:refreshItem];
		[refreshItem setEnabled:YES];
	}

	pages = parser.pages;
	currentPage = parser.currentPage;

	[parser release];

	[self finishedLoadingPage];
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	if(refreshEnabled) {
		[self.navigationItem setLeftBarButtonItem:refreshItem];
		[refreshItem setEnabled:YES];
	}

	pages = parser.pages;
	currentPage = parser.currentPage;

	[parser release];
	[self.navigationItem setRightBarButtonItem:nil];
}

#pragma mark -

- (void)loadURL {
	[self.navigationItem setRightBarButtonItem:activityItem];

	LeftFrameParser *parser = [[LeftFrameParser alloc] initWithURL:URL delegate:self];
	[parser parse];
}

- (void)refresh {
	refreshItem.enabled = NO;
	[self loadURL];
}

- (void)loadPage:(NSUInteger)page {
	NSMutableDictionary *queryDictionary = [self.URL queryDictionary];
	[queryDictionary setObject:[NSNumber numberWithUnsignedInteger:page] forKey:@"p"];
	self.URL = [self.URL URLBySettingQueryDictionary:queryDictionary];
	[self loadURL];
}

@end
