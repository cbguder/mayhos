//
//  TitleController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "TitleController.h"
#import "EksiTitleHeaderView.h"
#import "EntryController.h"
#import "PagePickerView.h"

@interface TitleController (Private)
- (void)resetHeaderView;
- (void)checkEmptyTitle;
- (void)showAlert;
- (void)resetNavigationBar;
- (void)resetHeaderView;
- (void)redrawHeader;
@end

@implementation TitleController

@synthesize tumuItem, eksiTitle;

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
	if(self = [super init]) {
		[self setEksiTitle:theTitle];
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

	self.tumuItem = [[UIBarButtonItem alloc] initWithTitle:@"tümü" style:UIBarButtonItemStyleBordered target:self action:@selector(tumuClicked:)];
	[tumuItem release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self redrawHeader];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([eksiTitle.entries count] == 0) {
		[self.navigationItem setRightBarButtonItem:activityItem];
		[eksiTitle loadEntries];
	} else if([eksiTitle isEmpty]) {
		[self showAlert];
	} else {
		[self redrawHeader];
		[self.tableView reloadData];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self redrawHeader];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if([eksiTitle isEmpty]) {
		return 0;
	}

	return [eksiTitle.entries count];
}

#define CONTENT_TAG 1
#define AUTHOR_TAG  2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *entryCellIdentifier = @"entryCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:entryCellIdentifier];

	UILabel *contentLabel;
	UILabel *authorLabel;

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
		[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
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
	[tumuItem release];
	[super dealloc];
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
	if([eksiTitle hasMoreToLoad]) {
		[self.navigationItem setRightBarButtonItem:tumuItem];
	} else {
		[super resetNavigationBar];
	}
}

- (void)resetHeaderView {
	if(![self.title isEqualToString:eksiTitle.title]) {
		self.title = eksiTitle.title;
		[self redrawHeader];
	}
}

- (void)redrawHeader {
	CGFloat width = 320.0;
	if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		width = 480.0;
	}

	CGSize size = [[eksiTitle title] sizeWithFont:[UIFont boldSystemFontOfSize:16]
								constrainedToSize:CGSizeMake(width - 20, CGFLOAT_MAX)
									lineBreakMode:UILineBreakModeWordWrap];

	EksiTitleHeaderView *headerView = [[EksiTitleHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, size.height + 20)];
	[headerView setText:eksiTitle.title];
	self.tableView.tableHeaderView = headerView;
	[headerView release];
}

#pragma mark -

- (void)tumuClicked:(id)sender {
	if(eksiTitle.hasMoreToLoad)	{
		[self.navigationItem setRightBarButtonItem:activityItem];
		[eksiTitle loadAllEntries];
	}
}

- (void)loadPage:(NSUInteger)page {
	[eksiTitle loadPage:page];
}

@end
