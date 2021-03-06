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
#import "TitleActionsHelper.h"
#import "EntryCell.h"

static CGFloat heightForEntry(EksiEntry *entry, CGFloat width) {
	CGSize size = [[entry plainTextContent] sizeWithFont:[UIFont systemFontOfSize:14]
									   constrainedToSize:CGSizeMake(width, 54)
										   lineBreakMode:UILineBreakModeTailTruncation];
	return size.height;
}

@interface TitleController (Private)
- (void)checkEmptyTitle;
- (void)showAlert;
- (void)reset;

- (BOOL)shouldHideToolbar;
- (void)resetToolbar;
@end

@implementation TitleController

@synthesize eksiTitle;
@synthesize titleView;
@synthesize actionItem;
@synthesize tumuItem;
@synthesize searchMode;
@synthesize noToolbar;

#pragma mark -
#pragma mark Initialization

- (id)initWithEksiTitle:(EksiTitle *)theTitle {
	if ((self = [super initWithStyle:UITableViewStylePlain])) {
		self.eksiTitle = theTitle;
		self.hidesBottomBarWhenPushed = YES;
	}

	return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setEksiTitle:(EksiTitle *)theTitle {
	if (theTitle != eksiTitle) {
		[eksiTitle setDelegate:nil];
		[eksiTitle release];
		eksiTitle = [theTitle retain];
		[eksiTitle setDelegate:self];

		self.numberOfPages = eksiTitle.pages;
		self.currentPage = eksiTitle.currentPage;
	}

	[self reset];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.actionItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)] autorelease];

	if (!searchMode) {
		self.tumuItem = [[UIBarButtonItem alloc] initWithTitle:@"tümünü göster" style:UIBarButtonItemStyleBordered target:self action:@selector(tumu)];
		[self.tumuItem release];

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

	self.titleView = [[TitleView alloc] initWithFrame:CGRectZero];
	titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleView.text = eksiTitle.title;
	[titleView release];

	self.navigationItem.titleView = titleView;

	[self resetToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:[self shouldHideToolbar] animated:animated];
	[self.titleView setFrame:CGRectMake(0, 0, 480, 44)];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if ([eksiTitle.entries count] == 0) {
		[self.navigationItem setRightBarButtonItem:activityItem];
		[eksiTitle loadEntries];
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
	return [eksiTitle.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	EntryCell *cell = (EntryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[EntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	[cell setEksiEntry:[eksiTitle.entries objectAtIndex:indexPath.row]];

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat width = 320.0;
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
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
	self.numberOfPages = eksiTitle.pages;
	self.currentPage = eksiTitle.currentPage;

	[self reset];

	if ([title.entries count] == 0 && self == self.navigationController.topViewController) {
		[self showAlert];
	} else {
		[self.tableView reloadData];

		if (searchMode) {
			[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
		} else {
			[self.tableView scrollRectToVisible:CGRectMake(0, 44, 1, 1) animated:NO];
			self.favorited = [[FavoritesManager sharedManager] hasFavoriteForTitle:eksiTitle.title];
			self.favoriteItem.enabled = YES;
		}
	}
}

- (void)title:(EksiTitle*)title didFailWithError:(NSError *)error {
	self.numberOfPages = eksiTitle.pages;
	self.currentPage = eksiTitle.currentPage;
}

#pragma mark -
#pragma mark Drawing

- (void)showAlert {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:eksiTitle.title
														message:@"burada pek bi'şey yok."
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"geri git ne bileyim", nil];
	[alertView show];
	[alertView release];
}

- (void)reset {
	if (![self.title isEqualToString:eksiTitle.title]) {
		self.navigationItem.title = eksiTitle.title;
		self.titleView.text = eksiTitle.title;
		self.navigationItem.titleView = titleView;
	}

	[self resetToolbar];
}

#pragma mark - Toolbar

- (BOOL)shouldHideToolbar {
	return (noToolbar || searchMode);
}

- (void)resetToolbar {
	if (![self isViewLoaded] || [self shouldHideToolbar]) {
		self.toolbarItems = nil;
		return;
	}

	NSMutableArray *items = [NSMutableArray array];

	[items addObject:self.favoriteItem];

	if ([eksiTitle hasMoreToLoad]) {
		[items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
		[items addObject:self.tumuItem];
	}

	[items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
	[items addObject:self.actionItem];

	self.toolbarItems = items;
}

#pragma mark - Actions

- (void)loadPage:(NSUInteger)page {
	[eksiTitle loadPage:page];
}

- (void)tumu {
	if (eksiTitle.hasMoreToLoad)	{
		[self.navigationItem setRightBarButtonItem:activityItem];
		[eksiTitle loadAllEntries];
	}
}

- (void)favorite {
	if (favorited) {
		[[FavoritesManager sharedManager] deleteFavoriteForTitle:eksiTitle.title];
	} else {
		[[FavoritesManager sharedManager] createFavoriteForTitle:eksiTitle.title];
	}

	[super favorite];
}

- (void)action {
	[[TitleActionsHelper sharedHelper] showActionSheetForViewController:self fromToolbar:self.navigationController.toolbar];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.actionItem = nil;
	self.tumuItem = nil;
	self.titleView = nil;
	self.toolbarItems = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[eksiTitle setDelegate:nil];
	[eksiTitle release];
	[super dealloc];
}

@end
