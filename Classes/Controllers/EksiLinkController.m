//
//  EksiLinkController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/28/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiLinkController.h"
#import "LeftFrameParser.h"

@implementation EksiLinkController

@synthesize titles, URL, refreshItem, refreshEnabled;

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

- (void)dealloc {
	[refreshItem release];
	[titles release];
	[URL release];

	[super dealloc];
}

- (void)loadURL {
	[self.navigationItem setRightBarButtonItem:activityItem];

	LeftFrameParser *parser = [[LeftFrameParser alloc] initWithURL:URL delegate:self];
	[parser parse];
}

- (void)refresh {
	refreshItem.enabled = NO;
	[self loadURL];
}

#pragma mark UIViewController Methods

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

#pragma mark UITableViewController Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *title = [[TitleController alloc] initWithEksiTitle:[titles objectAtIndex:[indexPath row]]];
	[self.navigationController pushViewController:title animated:YES];
	[title release];
}

#pragma mark EksiParserDelegate Methods

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

@end
