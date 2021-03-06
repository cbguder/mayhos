//
//  EksiLinkController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 28/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiLinkController.h"
#import "TitleController.h"
#import "NSURL+Query.h"
#import "FavoritesManager.h"
#import "TDBadgedCell.h"

@interface EksiLinkController ()
@property (nonatomic, retain) LeftFrameParser *parser;
@end

@implementation EksiLinkController

@synthesize links;
@synthesize URL;
@synthesize noToolbar;
@synthesize parser;

#pragma mark -
#pragma mark Initialization

- (id)init {
	if ((self = [self initWithCoder:nil])) {
		self.hidesBottomBarWhenPushed = YES;
	}

	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	self.toolbarItems = [NSArray arrayWithObjects:flexibleSpace, self.favoriteItem, nil];
	[flexibleSpace release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:(noToolbar || !self.hidesBottomBarWhenPushed) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if ([links count] == 0 && URL != nil) {
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

	TDBadgedCell *cell = (TDBadgedCell *)[tableView dequeueReusableCellWithIdentifier:linkCellIdentifier];
	if (cell == nil) {
		cell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:linkCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	EksiLink *link = [links objectAtIndex:indexPath.row];
	cell.textLabel.text = link.title;

	if (link.entryCount > 0) {
		cell.badgeString = [NSString stringWithFormat:@"%d", link.entryCount];
	} else {
		cell.badgeString = nil;
	}

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
#pragma mark Parser delegate

- (void)parserDidFinishParsing:(EksiParser *)aParser {
	self.links = [NSArray arrayWithArray:aParser.results];

	[self.tableView reloadData];
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	self.navigationItem.rightBarButtonItem = nil;

	self.numberOfPages = parser.pages;
	self.currentPage = parser.currentPage;

	self.parser = nil;

	self.favorited = [[FavoritesManager sharedManager] hasFavoriteForURL:self.URL];
	self.favoriteItem.enabled = YES;
}

- (void)parser:(EksiParser *)aParser didFailWithError:(NSError *)error {
	self.numberOfPages = aParser.pages;
	self.currentPage = aParser.currentPage;

	self.parser = nil;
	self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark -

- (void)loadURL {
	[self.navigationItem setRightBarButtonItem:activityItem];

	self.parser = [[LeftFrameParser alloc] initWithURL:URL delegate:self];
	[parser release];
	[parser parse];
}

- (void)loadPage:(NSUInteger)page {
	NSMutableDictionary *queryDictionary = [self.URL queryDictionary];
	[queryDictionary setObject:[NSNumber numberWithUnsignedInteger:page] forKey:@"p"];
	self.URL = [self.URL URLBySettingQueryDictionary:queryDictionary];
	[self loadURL];
}

- (void)favorite {
	if (favorited) {
		[[FavoritesManager sharedManager] deleteFavoriteForURL:self.URL];
	} else {
		[[FavoritesManager sharedManager] createFavoriteForURL:self.URL withTitle:self.title];
	}

	[super favorite];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.toolbarItems = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[parser setDelegate:nil];
	[parser release];
	[links release];
	[URL release];
	[super dealloc];
}

@end
