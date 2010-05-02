//
//  AuthorController.m
//  mayhos
//
//  Created by Can Berk Güder on 2/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "AuthorController.h"
#import "EksiLinkController.h"
#import "TitleController.h"

@implementation AuthorController

@synthesize author;

#pragma mark -
#pragma mark Initialization

- (id)initWithAuthor:(NSString *)theAuthor {
	if(self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.author = theAuthor;
		self.title = theAuthor;
	}

	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	if(indexPath.row == 0) {
		cell.textLabel.text = @"tüm entry'leri";
	} else if(indexPath.row == 1) {
		cell.textLabel.text = @"başlığı";
	}

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0) {
		EksiLinkController *linkController = [[EksiLinkController alloc] init];
		linkController.title = author;
		linkController.URL = [API URLForAdvancedSearchQuery:nil
													 author:author
											   sortCriteria:SortByDate
													   date:nil
													  guzel:NO];

		[self.navigationController pushViewController:linkController animated:YES];
		[linkController release];
	} else if(indexPath.row == 1) {
		EksiTitle *eksiTitle = [EksiTitle titleWithTitle:author URL:[API URLForTitle:author]];
		TitleController *titleController = [[TitleController alloc] initWithEksiTitle:eksiTitle];
		[self.navigationController pushViewController:titleController animated:YES];
		[titleController release];
	}
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 28)];

	label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16];
	label.text = author;

	[headerView addSubview:label];
	[label release];

	return [headerView autorelease];
}
*/

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[author release];
	[super dealloc];
}

- (void)viewDidUnload {
}

@end
