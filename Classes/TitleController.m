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

@interface TitleController (Private)
- (BOOL)hasLinkAtBottom;
@end

@implementation TitleController

@synthesize eksiTitle;

#pragma mark Initialization Methods

- (id)initWithTitle:(EksiTitle *)theTitle {
	if (self = [super init]) {
		[self setEksiTitle:theTitle];

		UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		[activityIndicatorView startAnimating];
		activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
		[activityIndicatorView release];
	}
	
	return self;
}

- (void)dealloc {
	[eksiTitle setDelegate:nil];
	[activityItem release];
	[eksiTitle release];

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
}

- (BOOL)hasLinkAtBottom {
	return (eksiTitle.loadedPages < eksiTitle.pages || eksiTitle.hasMoreToLoad);
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
	if([self hasLinkAtBottom]) {
		return 2;
	} else {
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0) {
		return [eksiTitle.entries count];
	} else {
		return 1;
	}
}

#define CONTENT_TAG 1
#define AUTHOR_TAG  2
#define LOAD_TAG    3
#define PAGES_TAG   4

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;

	static NSString *tumuLinkCellIdentifier = @"tumuLinkCell";
	static NSString *pageLinkCellIdentifier = @"pageLinkCell";
	static NSString *entryCellIdentifier = @"entryCell";

	if(indexPath.section == 0)
	{
		UILabel *contentLabel;
		UILabel *authorLabel;

		cell = [tableView dequeueReusableCellWithIdentifier:entryCellIdentifier];
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
		CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];

		contentLabel.frame = CGRectMake(10, 10, 280, height - 48);
		authorLabel.frame = CGRectMake(10, height - 28, 280, 18);

		contentLabel.text = entry.content;
		authorLabel.text = [entry signature];
	}
	else
	{
		UILabel *loadLabel;

		if(eksiTitle.hasMoreToLoad)
		{
			cell = [tableView dequeueReusableCellWithIdentifier:tumuLinkCellIdentifier];
			if(cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tumuLinkCellIdentifier] autorelease];

				loadLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 20, 300, 20)] autorelease];
				loadLabel.tag = LOAD_TAG;
				loadLabel.textColor = [UIColor colorWithRed:0.14 green:0.44 blue:0.85 alpha:1.0];
				loadLabel.font = [UIFont boldSystemFontOfSize:14];
				[cell.contentView addSubview:loadLabel];
			} else {
				loadLabel = (UILabel *)[cell.contentView viewWithTag:LOAD_TAG];
			}

			loadLabel.text = @"Tümünü Göster...";
		}
		else if(eksiTitle.loadedPages < eksiTitle.pages)
		{
			UILabel *pagesLabel;

			cell = [tableView dequeueReusableCellWithIdentifier:pageLinkCellIdentifier];
			if(cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:pageLinkCellIdentifier] autorelease];

				loadLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 13, 300, 18)] autorelease];
				loadLabel.tag = LOAD_TAG;
				loadLabel.font = [UIFont boldSystemFontOfSize:14];
				loadLabel.textColor = [UIColor colorWithRed:0.14 green:0.44 blue:0.85 alpha:1.0];
				[cell.contentView addSubview:loadLabel];
				
				pagesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 26, 300, 20)] autorelease];
				pagesLabel.tag = PAGES_TAG;
				pagesLabel.font = [UIFont systemFontOfSize:12];
				pagesLabel.textColor = [UIColor darkGrayColor];
				pagesLabel.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:pagesLabel];
			} else {
				loadLabel = (UILabel *)[cell.contentView viewWithTag:LOAD_TAG];
				pagesLabel = (UILabel *)[cell.contentView viewWithTag:PAGES_TAG];
			}
			
			loadLabel.text = [NSString stringWithFormat:@"%d. Sayfayı Yükle...", eksiTitle.loadedPages + 1];
			pagesLabel.text = [NSString stringWithFormat:@"Toplam %d sayfa", eksiTitle.pages];
		}
	}

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0)
	{
		NSString *content = [[eksiTitle.entries objectAtIndex:[indexPath row]] content];

		CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14]
						  constrainedToSize:CGSizeMake(280, 54)
							  lineBreakMode:UILineBreakModeTailTruncation];

		return size.height + 48;
	}
	else
	{
		return 60;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if(indexPath.section == 0)
	{
		EksiEntry *entry = [eksiTitle.entries objectAtIndex:indexPath.row];
		EntryController *entryController = [[EntryController alloc] initWithEntry:entry];

		[self.navigationController pushViewController:entryController animated:YES];
		[entryController release];
	}
	else if(indexPath.section == 1)
	{
		[self.navigationItem setRightBarButtonItem:activityItem];

		if(eksiTitle.hasMoreToLoad)	{
			[eksiTitle loadAllEntries];
		} else if(eksiTitle.loadedPages < eksiTitle.pages) {
			[eksiTitle loadOneMorePage];
		}

	}
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
	[self.navigationItem setRightBarButtonItem:nil];
	[self setEksiTitle:title];
	[self.tableView reloadData];
}

@end
