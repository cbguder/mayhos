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

@synthesize titles, URL;

#pragma mark Initialization Methods

- (void)viewDidLoad {
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	[activityIndicatorView startAnimating];
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	[activityIndicatorView release];
}

- (void)dealloc {
	[activityItem release];
	[titles release];
	[URL release];

	[super dealloc];
}

#pragma mark Other Methods

- (void)loadURL {
	[self.navigationItem setRightBarButtonItem:activityItem];

	LeftFrameParser *parser = [[LeftFrameParser alloc] initWithURL:URL delegate:self];
	[parser parse];
}

#pragma mark UIViewController Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
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
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:linkCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	cell.textLabel.text = [[titles objectAtIndex:[indexPath row]] title];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath	animated:YES];

	UIViewController *title = [[TitleController alloc] initWithEksiTitle:[titles objectAtIndex:[indexPath row]]];
	[self.navigationController pushViewController:title animated:YES];
	[title release];
}

#pragma mark EksiParserDelegate Methods

- (void)parserDidFinishParsing:(EksiParser *)parser {
	self.titles = [NSMutableArray arrayWithArray:parser.results];
	[parser release];
	[self.tableView reloadData];
	[self.navigationItem setRightBarButtonItem:nil];
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	[parser release];
	[self.navigationItem setRightBarButtonItem:nil];
}

@end
