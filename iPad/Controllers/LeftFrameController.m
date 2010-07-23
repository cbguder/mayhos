//
//  LeftFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "LeftFrameController.h"
#import "RightFrameController.h"
#import "LeftFrameParser.h"
#import "NSURL+Query.h"
#import "EksiLink.h"
#import "EksiTitle.h"

@interface LeftFrameController ()
- (void)loadURL;
@end

@implementation LeftFrameController

@synthesize links, URL;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([links count] == 0 && URL != nil) {
		[self loadURL];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
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
	}

	EksiLink *link = [links objectAtIndex:indexPath.row];
	cell.textLabel.text = link.title;

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	EksiLink *link = [links objectAtIndex:indexPath.row];
	UIAppDelegatePad.rightFrameController.eksiTitle = [EksiTitle titleForLink:link];
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
	self.currentPage = parser.currentPage;
	self.pages = parser.pages;

	self.links = [NSArray arrayWithArray:parser.results];

	[self.tableView reloadData];
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

	[parser release];
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	[parser release];
}

#pragma mark -

- (void)loadURL {
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
