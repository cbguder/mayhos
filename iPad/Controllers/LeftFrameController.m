//
//  LeftFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "LeftFrameController.h"
#import "RightFrameController.h"
#import "FavoritesManager.h"
#import "LeftFrameParser.h"
#import "NSURL+Query.h"
#import "EksiLink.h"
#import "EksiTitle.h"
#import "TDBadgedCell.h"

@interface LeftFrameController ()
- (void)loadURL;
@end

@implementation LeftFrameController

@synthesize links;
@synthesize URL;
@synthesize favoriteItem;
@synthesize favoritable;
@synthesize favorited;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.clearsSelectionOnViewWillAppear = NO;

	if (favoritable) {
		self.favoriteItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
		favoriteItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
		[favoriteItem release];

		self.favorited = favorited;

		UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		self.toolbarItems = [NSArray arrayWithObjects:flexibleSpaceItem, favoriteItem, nil];
		[flexibleSpaceItem release];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if ([links count] == 0 && URL != nil) {
		[self loadURL];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (favoritable) {
		[self.navigationController setToolbarHidden:NO animated:animated];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if (favoritable) {
		[self.navigationController setToolbarHidden:YES animated:animated];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Accessors

- (void)setFavorited:(BOOL)theFavorited {
	favorited = theFavorited;

	if (favorited) {
		favoriteItem.image = [UIImage imageNamed:@"Star.png"];
	} else {
		favoriteItem.image = [UIImage imageNamed:@"Star-Hollow.png"];
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
	UIAppDelegatePad.rightFrameController.eksiTitle = [EksiTitle titleForLink:link];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.favoriteItem = nil;
	self.toolbarItems = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[favoriteItem release];
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

	if (favoritable) {
		self.favorited = [[FavoritesManager sharedManager] hasFavoriteForURL:URL];
	}

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

- (void)favorite {
	if (favorited) {
		[[FavoritesManager sharedManager] deleteFavoriteForURL:self.URL];
	} else {
		[[FavoritesManager sharedManager] createFavoriteForURL:self.URL withTitle:self.title];
	}

	self.favorited = !self.favorited;
}

@end
