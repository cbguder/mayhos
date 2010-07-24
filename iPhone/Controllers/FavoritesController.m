//
//  FavoritesController.m
//  mayhos
//
//  Created by Can Berk Güder on 15/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritesController.h"
#import "FavoritedController.h"
#import "EksiLinkController.h"
#import "TitleController.h"
#import "FavoritesManager.h"

@implementation FavoritesController

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [UIAppDelegatePhone shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	if (cell.imageView.image) {
		cell.indentationLevel = 0;
	} else {
		cell.indentationLevel = 1;
		cell.indentationWidth = 24.0;
	}

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *favorite = [[[FavoritesManager sharedManager] favorites] objectAtIndex:indexPath.row];

	FavoriteType type = [[favorite objectForKey:@"type"] unsignedIntValue];
	NSString *title = [favorite objectForKey:@"title"];

	FavoritedController *favoritedController;

	if (type == FavoriteTypeTitle) {
		EksiTitle *eksiTitle = [EksiTitle titleWithTitle:title URL:[API URLForTitle:title]];
		favoritedController = [[TitleController alloc] initWithEksiTitle:eksiTitle];
	} else if (type == FavoriteTypeSearch) {
		favoritedController = [[EksiLinkController alloc] init];
		favoritedController.title = title;
		((EksiLinkController *)favoritedController).URL = [API URLForPath:[favorite objectForKey:@"URL"]];
	}

	favoritedController.favorited = YES;
	[self.navigationController pushViewController:favoritedController animated:YES];
	[favoritedController release];
}

@end
