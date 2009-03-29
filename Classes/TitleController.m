//
//  TitleController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "TitleController.h"
#import "EksiTitleHeaderView.h"
#import "EksiEntryCell.h"

@interface TitleController (Private)
- (BOOL)hasLinkAtBottom;
@end

@implementation TitleController

@synthesize eksiTitle;

#pragma mark Initialization Methods

- (id)initWithTitle:(EksiTitle *)theTitle {
	if (self = [super init]) {
		[self setEksiTitle:theTitle];

		CGSize size = [[theTitle title] sizeWithFont:[UIFont boldSystemFontOfSize:16]
								   constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)
									   lineBreakMode:UILineBreakModeWordWrap];

		EksiTitleHeaderView *headerView = [[EksiTitleHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, size.height + 20)];
		[headerView setText:theTitle.title];
		self.tableView.tableHeaderView = headerView;
		[headerView release];

		UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		[activityIndicatorView startAnimating];
		activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
		[activityIndicatorView release];
	}
	
	return self;
}

- (void)dealloc {
	[eksiTitle setDelegate:nil];
	[eksiTitle release];

	[super dealloc];
}

#pragma mark Accessors

- (void)setEksiTitle:(EksiTitle *)theTitle {
	[theTitle retain];
	[eksiTitle release];
	eksiTitle = theTitle;
	
	self.title = eksiTitle.title;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;

	if(indexPath.section == 0)
	{
		cell = [[[EksiEntryCell alloc] initWithFrame:CGRectZero] autorelease];
		[(EksiEntryCell *)cell setEntry:[eksiTitle.entries objectAtIndex:indexPath.row]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	else
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;

		UILabel *loadLabel;

		if(eksiTitle.hasMoreToLoad)
		{
			loadLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 20, 300, 20)] autorelease];
			loadLabel.font = [UIFont boldSystemFontOfSize:14];
			loadLabel.textColor = [UIColor colorWithRed:0.14 green:0.44 blue:0.85 alpha:1.0];
			loadLabel.text = @"Tümünü Göster...";
		}
		else if(eksiTitle.loadedPages < eksiTitle.pages)
		{
			loadLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 13, 300, 18)] autorelease];
			loadLabel.font = [UIFont boldSystemFontOfSize:14];
			loadLabel.textColor = [UIColor colorWithRed:0.14 green:0.44 blue:0.85 alpha:1.0];
			loadLabel.text = [NSString stringWithFormat:@"%d. Sayfayı Yükle...", eksiTitle.loadedPages + 1];

			UILabel *pagesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 26, 300, 20)] autorelease];
			pagesLabel.font = [UIFont systemFontOfSize:12];
			pagesLabel.textColor = [UIColor darkGrayColor];
			pagesLabel.backgroundColor = [UIColor clearColor];
			pagesLabel.text = [NSString stringWithFormat:@"Toplam %d sayfa", eksiTitle.pages];

			[cell.contentView addSubview:pagesLabel];
		}

		[cell.contentView addSubview:loadLabel];
	}

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0)
	{
		NSString *content = [[eksiTitle.entries objectAtIndex:[indexPath row]] content];

		CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14]
						  constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)
							  lineBreakMode:UILineBreakModeWordWrap];

		return size.height + 54;
	}
	else
	{
		return 60;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 1)
	{
		[self.navigationItem setRightBarButtonItem:activityItem];

		if(eksiTitle.hasMoreToLoad)	{
			[eksiTitle loadAllEntries];
		} else if(eksiTitle.loadedPages < eksiTitle.pages) {
			[eksiTitle loadOneMorePage];
		}

		[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	[self.tableView reloadData];
}

@end
