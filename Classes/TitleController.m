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
- (BOOL)hasLinkAtBottom;
@end

@implementation TitleController

@synthesize eksiTitle;

#pragma mark Static Methods

static CGFloat heightForEntry(EksiEntry *entry) {
	CGSize size = [[entry content] sizeWithFont:[UIFont systemFontOfSize:14]
							  constrainedToSize:CGSizeMake(280, 54)
								  lineBreakMode:UILineBreakModeTailTruncation];

	return size.height;
}

#pragma mark Initialization Methods

- (id)initWithTitle:(EksiTitle *)theTitle {
	if (self = [super init]) {
		UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		[activityIndicatorView startAnimating];
		activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
		[activityIndicatorView release];

		pagesItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(pagesClicked:)];
		tumuItem = [[UIBarButtonItem alloc] initWithTitle:@"tümü" style:UIBarButtonItemStyleBordered target:self action:@selector(tumuClicked:)];

		[self setEksiTitle:theTitle];
	}

	return self;
}

- (void)dealloc {
	[eksiTitle setDelegate:nil];
	[activityItem release];
	[pagePicker release];
	[eksiTitle release];
	[tumuItem release];

	[super dealloc];
}

#pragma mark Accessors

- (void)setEksiTitle:(EksiTitle *)theTitle {
	[theTitle retain];
	[eksiTitle release];
	eksiTitle = theTitle;

	self.title = eksiTitle.title;

	CGSize size = [[eksiTitle title] sizeWithFont:[UIFont boldSystemFontOfSize:16]
								constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)
									lineBreakMode:UILineBreakModeWordWrap];

	EksiTitleHeaderView *headerView = [[EksiTitleHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, size.height + 20)];
	[headerView setText:eksiTitle.title];
	self.tableView.tableHeaderView = headerView;
	[headerView release];

	[eksiTitle setDelegate:self];

	if([eksiTitle hasMoreToLoad]) {
		[self.navigationItem setRightBarButtonItem:tumuItem];
	} else if(eksiTitle.pages > 1) {
		[pagesItem setTitle:[NSString stringWithFormat:@"%d/%d", eksiTitle.currentPage, eksiTitle.pages]];
		[self.navigationItem setRightBarButtonItem:pagesItem];
	} else {
		[self.navigationItem setRightBarButtonItem:nil];
	}
}

#pragma mark Link Buttons

- (void)tumuClicked:(id)sender {
	if(eksiTitle.hasMoreToLoad)	{
		[self.navigationItem setRightBarButtonItem:activityItem];
		[eksiTitle loadAllEntries];
	}
}

- (void)pagesClicked:(id)sender {
	if(pagePicker == nil) {
		pagePicker = [[PagePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		pagePicker.delegate = self;
	}

	[pagePicker setSelectedPage:eksiTitle.currentPage];
	[self.view.window addSubview:pagePicker];
}

- (void)pagePicked:(NSInteger)page {
	[self.navigationItem setRightBarButtonItem:activityItem];
	[eksiTitle loadPage:page + 1];
}

#pragma mark UIPickerView Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%d", row + 1];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [eksiTitle pages];
}

#pragma mark UIViewController Methods

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([eksiTitle.entries count] == 0) {
		[self.navigationItem setRightBarButtonItem:activityItem];
		[eksiTitle loadEntries];
	}
}

#pragma mark UITableViewController Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:entryCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		contentLabel.tag = CONTENT_TAG;
		contentLabel.font = [UIFont systemFontOfSize:14];
		contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
		contentLabel.numberOfLines = 3;
		[cell.contentView addSubview:contentLabel];
		[contentLabel release];

		authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		authorLabel.tag = AUTHOR_TAG;
		authorLabel.textAlignment = UITextAlignmentRight;
		authorLabel.font = [UIFont systemFontOfSize:14];
		[cell.contentView addSubview:authorLabel];
		[authorLabel release];
	} else {
		contentLabel = (UILabel *)[cell.contentView viewWithTag:CONTENT_TAG];
		authorLabel = (UILabel *)[cell.contentView viewWithTag:AUTHOR_TAG];
	}

	EksiEntry *entry = [eksiTitle.entries objectAtIndex:indexPath.row];
	CGFloat height = heightForEntry(entry);

	contentLabel.frame = CGRectMake(10, 10, 280, height);
	authorLabel.frame = CGRectMake(10, height + 20, 280, 18);

	contentLabel.text = entry.content;
	authorLabel.text = [entry signature];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	EksiEntry *entry = [eksiTitle.entries objectAtIndex:[indexPath row]];
	return heightForEntry(entry) + 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	EksiEntry *entry = [eksiTitle.entries objectAtIndex:indexPath.row];
	EntryController *entryController = [[EntryController alloc] initWithEntry:entry];

	[self.navigationController pushViewController:entryController animated:YES];
	[entryController release];
}

#pragma mark EksiTitleDelegate Methods

- (void)title:(EksiTitle*)title didFailLoadingEntriesWithError:(NSError *)error {
	[self.navigationItem setRightBarButtonItem:nil];

	NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];

	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Content"
														  message:errorMessage
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];

	[errorAlert show];
}

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	[self setEksiTitle:title];
	[self.tableView reloadData];
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

@end
