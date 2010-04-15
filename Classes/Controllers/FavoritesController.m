//
//  FavoritesController.m
//  mayhos
//
//  Created by Can Berk Güder on 15/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritesController.h"
#import "EksiLinkController.h"
#import "FavoritesManager.h"

@implementation FavoritesController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[FavoritesManager sharedManager] favorites] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *favoriteCellIdentifier = @"favoriteCellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:favoriteCellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:favoriteCellIdentifier] autorelease];
	}

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	NSDictionary *favorite = [[[FavoritesManager sharedManager] favorites] objectAtIndex:indexPath.row];
	cell.textLabel.text = [favorite objectForKey:@"title"];

	if([[favorite objectForKey:@"type"] isEqualToNumber:[NSNumber numberWithUnsignedInt:FavoriteTypeSearch]]) {
		cell.imageView.image = [UIImage imageNamed:@"Search.png"];
	} else {
		cell.indentationLevel = 1;
		cell.indentationWidth = 24.0;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		[[FavoritesManager sharedManager] deleteFavoriteAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	[[FavoritesManager sharedManager] moveFavoriteAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *favorite = [[[FavoritesManager sharedManager] favorites] objectAtIndex:indexPath.row];

	FavoriteType type = [[favorite objectForKey:@"type"] unsignedIntValue];
	NSString *title = [favorite objectForKey:@"title"];

	if(type == FavoriteTypeTitle) {
		EksiTitle *eksiTitle = [EksiTitle titleWithTitle:title URL:[API URLForTitle:title]];
		TitleController *titleController = [[TitleController alloc] initWithEksiTitle:eksiTitle];
		[self.navigationController pushViewController:titleController animated:YES];
		[titleController release];
	} else if(type == FavoriteTypeSearch) {
		EksiLinkController *linkController = [[EksiLinkController alloc] init];
		linkController.title = title;
		linkController.URL = [NSURL URLWithString:[favorite objectForKey:@"URL"]];
		[self.navigationController pushViewController:linkController animated:YES];
		[linkController release];
	}
}

@end
