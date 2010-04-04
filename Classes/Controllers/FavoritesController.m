//
//  FavoritesController.m
//  mayhos
//
//  Created by Can Berk Güder on 15/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritesController.h"
#import "EksiLinkController.h"

#define kFavoriteTypeTitle  0
#define kFavoriteTypeSearch 1

@interface FavoritesController (Private)
- (void)saveFavorites;
@end

@implementation FavoritesController

@synthesize favorites;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	self.favorites = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"favorites"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [favorites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *favoriteCellIdentifier = @"favoriteCellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:favoriteCellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:favoriteCellIdentifier] autorelease];
	}

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	NSDictionary *favorite = [favorites objectAtIndex:indexPath.row];
	cell.textLabel.text = [favorite objectForKey:@"title"];

	if([[favorite objectForKey:@"type"] isEqualToNumber:[NSNumber numberWithInt:kFavoriteTypeSearch]]) {
		cell.imageView.image = [UIImage imageNamed:@"Search.png"];
	} else {
		cell.indentationLevel = 1;
		cell.indentationWidth = 24.0;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		[favorites removeObjectAtIndex:indexPath.row];
		[self saveFavorites];

		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	if(fromIndexPath.row != toIndexPath.row) {
		id obj = [favorites objectAtIndex:fromIndexPath.row];
		[obj retain];
		[favorites removeObjectAtIndex:fromIndexPath.row];

		if(toIndexPath.row >= [favorites count]) {
			[favorites addObject:obj];
		} else {
			[favorites insertObject:obj atIndex:toIndexPath.row];
		}

		[obj release];
		[self saveFavorites];
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *favorite = [favorites objectAtIndex:indexPath.row];

	NSString *title = [favorite objectForKey:@"title"];
	NSURL *URL = [NSURL URLWithString:[favorite objectForKey:@"URL"]];
	NSUInteger type = [[favorite objectForKey:@"type"] unsignedIntValue];

	if(type == kFavoriteTypeTitle) {
		EksiTitle *eksiTitle = [[EksiTitle alloc] init];
		[eksiTitle setTitle:title];
		[eksiTitle setURL:URL];

		TitleController *titleController = [[TitleController alloc] initWithEksiTitle:eksiTitle];
		[self.navigationController pushViewController:titleController animated:YES];

		[titleController release];
		[eksiTitle release];
	} else if(type == kFavoriteTypeSearch) {
		EksiLinkController *linkController = [[EksiLinkController alloc] init];
		[linkController setTitle:title];
		[linkController setURL:URL];
		[self.navigationController pushViewController:linkController animated:YES];
		[linkController release];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[favorites release];
    [super dealloc];
}

- (void)viewDidUnload {
	self.favorites = nil;
}

#pragma mark -

- (void)saveFavorites {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:favorites forKey:@"favorites"];
	[defaults synchronize];
}

@end
