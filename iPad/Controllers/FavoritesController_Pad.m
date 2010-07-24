//
//  FavoritesController_Pad.m
//  mayhos
//
//  Created by Can Berk Güder on 2/6/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritesController_Pad.h"
#import "FavoritedLeftFrameController.h"
#import "FavoritesManager.h"

@implementation FavoritesController_Pad

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(favoritesSaved:)
												 name:@"FavoritesSaved"
											   object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

	if (cell.imageView.image) {
		UIImageView *accessoryView = [[UIImageView alloc] initWithImage:cell.imageView.image
													   highlightedImage:cell.imageView.highlightedImage];
		cell.accessoryView = accessoryView;
		[accessoryView release];

		cell.imageView.image = nil;
		cell.imageView.highlightedImage = nil;
	}

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *favorite = [[[FavoritesManager sharedManager] favorites] objectAtIndex:indexPath.row];

	FavoriteType type = [[favorite objectForKey:@"type"] unsignedIntValue];
	NSString *title = [favorite objectForKey:@"title"];

	if (type == FavoriteTypeTitle) {
		EksiTitle *eksiTitle = [EksiTitle titleWithTitle:title URL:[API URLForTitle:title]];
		UIAppDelegatePad.rightFrameController.eksiTitle = eksiTitle;
	} else if (type == FavoriteTypeSearch) {
		FavoritedLeftFrameController *leftFrameController = [[FavoritedLeftFrameController alloc] init];
		leftFrameController.URL = [API URLForPath:[favorite objectForKey:@"URL"]];
		leftFrameController.favorited = YES;
		leftFrameController.title = title;

		[self.navigationController pushViewController:leftFrameController animated:YES];
		[leftFrameController release];
	}
}

#pragma mark -

- (void)favoritesSaved:(NSNotification *)notification {
	[self.tableView reloadData];
}

@end
