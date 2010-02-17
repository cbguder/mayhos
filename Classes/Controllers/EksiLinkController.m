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

- (id)init {
	if(self = [super init]) {
		self.hidesBottomBarWhenPushed = YES;
	}

	return self;
}

- (void)dealloc {
	[titles release];
	[URL release];

	[super dealloc];
}

- (void)loadURL {
	[self.navigationItem setRightBarButtonItem:activityItem];

	LeftFrameParser *parser = [[LeftFrameParser alloc] initWithURL:URL delegate:self];
	[parser parse];
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
	[parser release];
	[self.tableView reloadData];
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	[self.navigationItem setRightBarButtonItem:nil];
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	[parser release];
	[self.navigationItem setRightBarButtonItem:nil];
}

@end
