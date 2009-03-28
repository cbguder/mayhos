//
//  TitleController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "TitleController.h"

@implementation TitleController

#pragma mark Initialization Methods

- (id)initWithTitle:(EksiTitle *)theTitle {
	if (self = [super init]) {
		[self setEksiTitle:theTitle];
	}
	
	return self;
}

- (void)dealloc {
	[eksiTitle release];

	[super dealloc];
}

#pragma mark Accessors

@synthesize eksiTitle;

- (void)setEksiTitle:(EksiTitle *)theTitle {
	[theTitle retain];
	[eksiTitle release];
	eksiTitle = theTitle;
	
	self.title = eksiTitle.title;
	myURL = eksiTitle.URL;

	[eksiTitle setDelegate:self];
}

#pragma mark UIViewController Methods

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([eksiTitle.entries count] == 0) {
		[eksiTitle setDelegate:self];
		[eksiTitle loadEntries];
	}
}

#pragma mark UITableViewController Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(eksiTitle.loadedPages < eksiTitle.pages || eksiTitle.hasMoreToLoad)
	{
		return [eksiTitle.entries count] + 1;
	}
	else
	{
		return [eksiTitle.entries count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];

	if(indexPath.row < [eksiTitle.entries count])
	{
		EksiEntry *entry = [eksiTitle.entries objectAtIndex:indexPath.row];

		UILabel *textView = [[[UILabel alloc] initWithFrame:CGRectMake(10, 7, 300, 20)] autorelease];
		textView.numberOfLines = 0;
		textView.lineBreakMode = UILineBreakModeWordWrap;
		textView.font = [UIFont systemFontOfSize:14];
		textView.text = entry.content;

		CGFloat pos = [self tableView:tableView heightForRowAtIndexPath:indexPath] - 24;
		UILabel *author = [[[UILabel alloc] initWithFrame:CGRectMake(10, pos, 300, 20)] autorelease];
		author.numberOfLines = 1;
		author.textAlignment = UITextAlignmentRight;
		author.font = [UIFont systemFontOfSize:14];
		author.text = [NSString stringWithFormat:@"%@, %@", entry.author, [entry dateString]];

		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		[cell.contentView addSubview:textView];
		[cell.contentView addSubview:author];
		[textView sizeToFit];
	}
	else if(eksiTitle.hasMoreToLoad)
	{
		UILabel *loadLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 20, 300, 20)] autorelease];
		loadLabel.font = [UIFont boldSystemFontOfSize:14];
		loadLabel.textColor = [UIColor colorWithRed:0.14 green:0.44 blue:0.85 alpha:1.0];
		loadLabel.text = @"Tümünü Göster...";

		cell.selectionStyle = UITableViewCellSelectionStyleBlue;

		[cell.contentView addSubview:loadLabel];
	}
	else if(eksiTitle.loadedPages < eksiTitle.pages)
	{
		UILabel *loadLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 13, 300, 18)] autorelease];
		loadLabel.font = [UIFont boldSystemFontOfSize:14];
		loadLabel.textColor = [UIColor colorWithRed:0.14 green:0.44 blue:0.85 alpha:1.0];
		loadLabel.text = [NSString stringWithFormat:@"%d. Sayfayı Yükle...", eksiTitle.loadedPages + 1];

		UILabel *pagesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 26, 300, 20)] autorelease];
		pagesLabel.font = [UIFont systemFontOfSize:12];
		pagesLabel.textColor = [UIColor darkGrayColor];
		pagesLabel.backgroundColor = [UIColor clearColor];
		pagesLabel.text = [NSString stringWithFormat:@"Toplam %d sayfa", eksiTitle.pages];

		cell.selectionStyle = UITableViewCellSelectionStyleBlue;

		[cell.contentView addSubview:loadLabel];
		[cell.contentView addSubview:pagesLabel];
	}

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row < [eksiTitle.entries count])
	{
		CGSize size = [[[eksiTitle.entries objectAtIndex:[indexPath row]] content] sizeWithFont:[UIFont systemFontOfSize:14]
																			  constrainedToSize:CGSizeMake(300, 4000)
																				  lineBreakMode:UILineBreakModeWordWrap];
		return size.height + 15 + 33;
	}
	else
	{
		return 60;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == [eksiTitle.entries count])
	{
		if(eksiTitle.hasMoreToLoad)
		{
			[eksiTitle loadAllEntries];
		}
		else if(eksiTitle.loadedPages < eksiTitle.pages || eksiTitle.hasMoreToLoad)
		{
			[eksiTitle loadOneMorePage];
		}

		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

#pragma mark EksiTitleDelegate Methods

- (void)title:(EksiTitle*)title didFailLoadingEntriesWithError:(NSError *)error {
	NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Content" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	[self.tableView reloadData];
}

@end
