//
//  TitleController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import "TitleController.h"

@implementation TitleController

#pragma mark Initialization Methods

- (id)initWithTitle:(EksiTitle *)theTitle {
	if (self = [super init]) {
		[self setEksiTitle:theTitle];
		
		UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
		[activityIndicator startAnimating];
		[activityIndicator sizeToFit];
		
		activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
		tumuItem = [[UIBarButtonItem alloc] initWithTitle:@"tumu"
													style:UIBarButtonItemStyleBordered
												   target:self
												   action:@selector(tumunu_goster)];
	}
	
	return self;
}

- (void)dealloc {
	[activityItem release];
	[eksiTitle release];
	[tumu_link release];
	[tumuItem release];

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
}

#pragma mark Other Methods

- (void)tumunu_goster {
	[self.navigationItem setRightBarButtonItem:activityItem animated:YES];
	[eksiTitle loadAllEntriesWithDelegate:self];
}

#pragma mark UIViewController Methods

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([eksiTitle.entries count] == 0) {
		[self.navigationItem setRightBarButtonItem:activityItem animated:YES];
		[eksiTitle loadEntriesWithDelegate:self];
	} else if(eksiTitle.hasMoreToLoad) {
		[self.navigationItem setRightBarButtonItem:tumuItem animated:NO];
	}
}

#pragma mark UITableViewController Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [eksiTitle.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	EksiEntry *entry = [eksiTitle.entries objectAtIndex:[indexPath row]];
	
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
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = [[[eksiTitle.entries objectAtIndex:[indexPath row]] content] sizeWithFont:[UIFont systemFontOfSize:14]
																		  constrainedToSize:CGSizeMake(300, 4000)
																			  lineBreakMode:UILineBreakModeWordWrap];
	return size.height + 15 + 33;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

#pragma mark EksiTitleDelegate Methods

- (void)title:(EksiTitle*)title didFailLoadingEntriesWithError:(NSError *)error {
	NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Content" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
	[errorAlert show];
}

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	if(title.hasMoreToLoad) {
		[self.navigationItem setRightBarButtonItem:tumuItem animated:YES];
	} else {
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
	}

	[self.tableView reloadData];
}

@end
