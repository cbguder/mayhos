//
//  TitleController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 24/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "TitleController.h"
#import "EntryController.h"
#import "PagePickerView.h"
#import "NSDictionary+URLEncoding.h"
#import "FavoritesManager.h"

@interface TitleController (Private)
- (void)checkEmptyTitle;
- (void)showAlert;
- (void)resetHeaderView;
- (NSArray *)toolbarItemsIncludingTumuItem:(BOOL)includeTumuItem;
@end

@implementation TitleController

@synthesize eksiTitle, titleView, tumuItem, searchMode;

#pragma mark -
#pragma mark Static methods

static CGFloat heightForEntry(EksiEntry *entry, CGFloat width) {
	CGSize size = [[entry plainTextContent] sizeWithFont:[UIFont systemFontOfSize:14]
									   constrainedToSize:CGSizeMake(width, 54)
										   lineBreakMode:UILineBreakModeTailTruncation];

	return size.height;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithEksiTitle:(EksiTitle *)theTitle {
	if(self = [super initWithStyle:UITableViewStylePlain]) {
		self.eksiTitle = theTitle;
		self.hidesBottomBarWhenPushed = YES;
	}

	return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setEksiTitle:(EksiTitle *)theTitle {
	if(theTitle != eksiTitle) {
		[eksiTitle setDelegate:nil];
		[eksiTitle release];
		eksiTitle = [theTitle retain];
		[eksiTitle setDelegate:self];

		pages = eksiTitle.pages;
		currentPage = eksiTitle.currentPage;
	}

	[self resetNavigationBar];
	[self resetHeaderView];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	if(!searchMode) {
		self.tumuItem = [[UIBarButtonItem alloc] initWithTitle:@"tümünü göster" style:UIBarButtonItemStyleBordered target:self action:@selector(tumu)];
		[self.tumuItem release];

		self.toolbarItems = [self toolbarItemsIncludingTumuItem:NO];

		UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		searchBar.placeholder = @"başlık içinde ara";
		searchBar.delegate = self;
		searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
		self.tableView.tableHeaderView = searchBar;
		self.tableView.contentOffset = CGPointMake(0, 44);

		UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
		searchDisplayController.delegate = self;
		[searchBar release];
	}

	self.titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, 400, 32)];
	titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleView.text = eksiTitle.title;
	[titleView release];

	self.navigationItem.titleView = titleView;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:searchMode animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([eksiTitle.entries count] == 0) {
		[self.navigationItem setRightBarButtonItem:activityItem];
		[eksiTitle loadEntries];
	} else if([eksiTitle isEmpty]) {
		[self showAlert];
	} else {
		[self.tableView reloadData];
		self.navigationItem.titleView = titleView;
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if([eksiTitle isEmpty]) {
		return 0;
	}

	return [eksiTitle.entries count];
}

#define CONTENT_TAG 1
#define AUTHOR_TAG  2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *entryCellIdentifier = @"Cell";

	UILabel *contentLabel;
	UILabel *authorLabel;

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:entryCellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:entryCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		contentLabel.tag = CONTENT_TAG;
		contentLabel.font = [UIFont systemFontOfSize:14];
		contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
		contentLabel.numberOfLines = 3;
		contentLabel.highlightedTextColor = [UIColor whiteColor];
		[cell.contentView addSubview:contentLabel];
		[contentLabel release];

		authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		authorLabel.tag = AUTHOR_TAG;
		authorLabel.textAlignment = UITextAlignmentRight;
		authorLabel.font = [UIFont systemFontOfSize:14];
		authorLabel.highlightedTextColor = [UIColor whiteColor];
		[cell.contentView addSubview:authorLabel];
		[authorLabel release];
	} else {
		contentLabel = (UILabel *)[cell.contentView viewWithTag:CONTENT_TAG];
		authorLabel = (UILabel *)[cell.contentView viewWithTag:AUTHOR_TAG];
	}

	CGFloat width = 320.0;
	if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		width = 480.0;
	}
	width -= 40.0;

	EksiEntry *entry = [eksiTitle.entries objectAtIndex:indexPath.row];
	CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];

	contentLabel.frame = CGRectMake(10, 10, width, height - 48.0);
	authorLabel.frame = CGRectMake(10, height - 28.0, width, 18);

	contentLabel.text = entry.plainTextContent;
	authorLabel.text = [entry signature];

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat width = 320.0;
	if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		width = 480.0;
	}
	width -= 40.0;

	EksiEntry *entry = [eksiTitle.entries objectAtIndex:indexPath.row];
	return heightForEntry(entry, width) + 48.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	EntryController *entryController = [[EntryController alloc] initWithEksiTitle:eksiTitle index:indexPath.row];
	[self.navigationController pushViewController:entryController animated:YES];
	[entryController release];
}

#pragma mark -
#pragma mark Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	EksiTitle *searchTitle = [EksiTitle titleWithTitle:eksiTitle.title URL:[API URLForTitle:eksiTitle.title withSearchQuery:searchBar.text]];
	TitleController *searchController = [[TitleController alloc] initWithEksiTitle:searchTitle];
	searchController.searchMode = YES;

	[self.navigationController pushViewController:searchController animated:YES];
	[searchController release];

	[self.searchDisplayController setActive:NO animated:YES];
}

#pragma mark -
#pragma mark Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[controller.searchResultsTableView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
	[controller.searchResultsTableView setRowHeight:800];

	return NO;
}

#pragma mark -
#pragma mark Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Title delegate

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	pages = eksiTitle.pages;
	currentPage = eksiTitle.currentPage;
	[super finishedLoadingPage];

	[self resetHeaderView];

	if([title isEmpty]) {
		[self showAlert];
	} else {
		[self.tableView reloadData];

		if(searchMode) {
			[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
		} else {
			[self.tableView scrollRectToVisible:CGRectMake(0, 44, 1, 1) animated:NO];
			self.favorited = [[FavoritesManager sharedManager] hasFavoriteForTitle:eksiTitle.title];
			self.favoriteItemEnabled = YES;
		}
	}
}

- (void)title:(EksiTitle*)title didFailWithError:(NSError *)error {
	pages = eksiTitle.pages;
	currentPage = eksiTitle.currentPage;
	[super finishedLoadingPage];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[eksiTitle setDelegate:nil];
	[eksiTitle release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.tumuItem = nil;
	self.titleView = nil;
	self.toolbarItems = nil;
}

#pragma mark -
#pragma mark Drawing

- (void)showAlert {
	EksiEntry *firstEntry = [eksiTitle.entries objectAtIndex:0];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:eksiTitle.title
														message:firstEntry.plainTextContent
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"geri git ne bileyim", nil];
	[alertView show];
	[alertView release];
}

- (void)resetNavigationBar {
	[super resetNavigationBar];

	if(!searchMode && [self isViewLoaded]) {
		self.toolbarItems = [self toolbarItemsIncludingTumuItem:[eksiTitle hasMoreToLoad]];
	}
}

- (void)resetHeaderView {
	if(![self.title isEqualToString:eksiTitle.title]) {
		self.navigationItem.title = eksiTitle.title;
		self.titleView.text = eksiTitle.title;
		self.navigationItem.titleView = titleView;
	}
}

#pragma mark -

- (void)loadPage:(NSUInteger)page {
	[eksiTitle loadPage:page];
}

- (void)tumu {
	if(eksiTitle.hasMoreToLoad)	{
		[self.navigationItem setRightBarButtonItem:activityItem];
		[eksiTitle loadAllEntries];
	}
}

- (void)favorite {
	if(favorited) {
		[[FavoritesManager sharedManager] deleteFavoriteForTitle:eksiTitle.title];
	} else {
		[[FavoritesManager sharedManager] createFavoriteForTitle:eksiTitle.title];
	}

	[super favorite];
}

- (NSArray *)toolbarItemsIncludingTumuItem:(BOOL)includeTumuItem {
	NSMutableArray *items = [NSMutableArray array];

	if(includeTumuItem) {
		[items addObject:self.tumuItem];
	}

	[items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
	[items addObject:self.favoriteItem];

	return items;
}

@end
