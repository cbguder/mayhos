//
//  FavoritesController_Pad.m
//  mayhos
//
//  Created by Can Berk Güder on 2/6/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritesController_Pad.h"
#import "LeftFrameController.h";
#import "FavoritesManager.h"

@implementation FavoritesController_Pad

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[FavoritesManager sharedManager] favorites] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	NSDictionary *favorite = [[[FavoritesManager sharedManager] favorites] objectAtIndex:indexPath.row];
	cell.textLabel.text = [favorite objectForKey:@"title"];

	if([[favorite objectForKey:@"type"] isEqualToNumber:[NSNumber numberWithUnsignedInt:FavoriteTypeSearch]]) {
		cell.imageView.image = [UIImage imageNamed:@"Search.png"];
		cell.imageView.highlightedImage = [UIImage imageNamed:@"Search-Highlighted.png"];
		cell.indentationLevel = 0;
	} else {
		cell.imageView.image = nil;
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
		UINavigationController *navController = [self.splitViewController.viewControllers objectAtIndex:1];
		RightFrameController *rightFrameController = (RightFrameController *)navController.topViewController;
		rightFrameController.eksiTitle = eksiTitle;
	} else if(type == FavoriteTypeSearch) {
		LeftFrameController *leftFrameController = [[LeftFrameController alloc] init];
		leftFrameController.URL = [NSURL URLWithString:[favorite objectForKey:@"URL"]];
		leftFrameController.title = title;

		[self.navigationController pushViewController:leftFrameController animated:YES];
		[leftFrameController release];
	}
}

@end
