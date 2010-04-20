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

@synthesize links, URL;

#pragma mark -
#pragma mark Initialization

- (id)init {
	if(self = [self initWithCoder:nil]) {
		self.hidesBottomBarWhenPushed = YES;
	}

	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([links count] == 0 && URL != nil) {
		[self loadURL];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [links count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *linkCellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:linkCellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:linkCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	cell.textLabel.text = [[links objectAtIndex:indexPath.row] title];

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	EksiLink *link = [links objectAtIndex:indexPath.row];
	TitleController *titleController = [[TitleController alloc] initWithEksiTitle:[EksiTitle titleForLink:link]];
	[self.navigationController pushViewController:titleController animated:YES];
	[titleController release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[links release];
	[URL release];
	[super dealloc];
}

#pragma mark -
#pragma mark Parser delegate

- (void)parserDidFinishParsing:(EksiParser *)parser {
	self.links = [NSArray arrayWithArray:parser.results];

	[self.tableView reloadData];
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	[self.navigationItem setRightBarButtonItem:nil];

	pages = parser.pages;
	currentPage = parser.currentPage;

	[parser release];

	[self finishedLoadingPage];
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
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

- (void)loadPage:(NSUInteger)page {
	NSMutableDictionary *queryDictionary = [self.URL queryDictionary];
	[queryDictionary setObject:[NSNumber numberWithUnsignedInteger:page] forKey:@"p"];
	self.URL = [self.URL URLBySettingQueryDictionary:queryDictionary];
	[self loadURL];
}

@end
