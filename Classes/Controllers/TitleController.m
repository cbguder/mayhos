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

#define kAlertViewNotFound 0
#define kAlertViewSearch   1

@interface TitleController (Private)
- (void)checkEmptyTitle;
- (void)showAlert;
- (void)resetHeaderView;
- (NSArray *)toolbarItemsIncludingTumuItem:(BOOL)includeTumuItem;
@end

@implementation TitleController

@synthesize eksiTitle, titleView, favoriteItem, searchItem, tumuItem, searchMode, favorited;

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

- (void)setFavorited:(BOOL)theFavorited {
	favorited = theFavorited;

	if(favorited) {
		self.favoriteItem.image = [UIImage imageNamed:@"Star.png"];
	} else {
		self.favoriteItem.image = [UIImage imageNamed:@"StarHollow.png"];
	}
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	if(!searchMode) {
		self.searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
		self.searchItem.enabled = NO;
		[self.searchItem release];

		self.tumuItem = [[UIBarButtonItem alloc] initWithTitle:@"tümünü göster" style:UIBarButtonItemStyleBordered target:self action:@selector(tumu)];
		[self.tumuItem release];

		self.favoriteItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"StarHollow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
		self.favoriteItem.enabled = NO;
		[self.favoriteItem release];

		self.toolbarItems = [self toolbarItemsIncludingTumuItem:NO];
	}

	self.titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, 400, 32)];
	titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleView.text = eksiTitle.title;
	[titleView release];

	self.navigationItem.titleView = titleView;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if(!searchMode) {
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if(!searchMode) {
		[self.navigationController setToolbarHidden:YES animated:YES];
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
#pragma mark Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == kAlertViewNotFound) {
		[self.navigationController popViewControllerAnimated:YES];
	} else if(alertView.tag == kAlertViewSearch) {
		if(buttonIndex == 1) {
			NSString *searchText = [[alertView textField] text];

			if([searchText isEqualToString:@""]) {
				return;
			}

			EksiTitle *searchTitle = [EksiTitle titleWithTitle:eksiTitle.title URL:[API URLForTitle:eksiTitle.title withSearchQuery:searchText]];
			TitleController *searchController = [[TitleController alloc] initWithEksiTitle:searchTitle];
			searchController.searchMode = YES;

			[self.navigationController pushViewController:searchController animated:YES];
			[searchController release];
		}
	}
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
		[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	}

	if(!searchMode) {
		self.favorited = [[FavoritesManager sharedManager] hasFavoriteForTitle:eksiTitle.title];
		self.favoriteItem.enabled = YES;
		self.searchItem.enabled = YES;
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
	self.titleView = nil;

	self.favoriteItem = nil;
	self.searchItem = nil;
	self.tumuItem = nil;

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
	[alertView setTag:kAlertViewNotFound];
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

	self.favorited = !self.favorited;
}

- (void)search {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"başlık içinde ara"
														message:nil
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"Search", nil];

	[alertView setTag:kAlertViewSearch];
	[alertView addTextFieldWithValue:nil label:nil];
	[[alertView textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
	[alertView show];
	[alertView release];
}

- (NSArray *)toolbarItemsIncludingTumuItem:(BOOL)includeTumuItem {
	NSMutableArray *items = [NSMutableArray array];
	[items addObject:self.searchItem];
	[items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

	if(includeTumuItem) {
		[items addObject:self.tumuItem];
		[items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
	}

	[items addObject:self.favoriteItem];

	return items;
}

@end
