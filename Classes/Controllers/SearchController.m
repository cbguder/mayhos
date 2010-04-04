//
//  SearchController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "SearchController.h"
#import "AdvancedSearchController.h"

@interface SearchController (Private)
- (void)saveHistory;
- (void)saveSearch:(NSString *)search;
- (void)search:(NSString *)query;
- (void)go:(NSString *)query;
@end

@implementation SearchController

@synthesize history, matches, searchTerm, advancedSearchItem;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	NSArray *original = [[NSUserDefaults standardUserDefaults] arrayForKey:@"history"];
	self.history = [NSMutableSet setWithArray:original];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		if(section == 0) {
			return 2;
		} else {
			return [self.matches count];
		}
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	if(indexPath.section == 0) {
		cell.textLabel.textColor = [UIColor colorWithRed:36.0/255.0 green:112.0/255.0 blue:216.0/255.0 alpha:1.0];

		if(indexPath.row == 0) {
			cell.textLabel.text = @"getir";
		} else {
			cell.textLabel.text = @"ara";
		}
	} else {
		cell.textLabel.text = [self.matches objectAtIndex:indexPath.row];
	}

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == 1);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		[self.history removeObject:[self.matches objectAtIndex:indexPath.row]];
		[self.matches removeObjectAtIndex:indexPath.row];
		[self saveHistory];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0) {
		if(indexPath.row == 0) {
			[self go:searchTerm];
		} else {
			[self search:searchTerm];
		}
	} else {
		[self search:[self.matches objectAtIndex:indexPath.row]];
	}
}

#pragma mark -
#pragma mark Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self search:searchTerm];
}

#pragma mark -
#pragma mark Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	self.searchTerm = searchString;

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@", [NSString stringWithFormat:@"*%@*", searchString]];
	self.matches = [NSMutableArray arrayWithArray:[self.history allObjects]];
	[self.matches filterUsingPredicate:predicate];
	[self.matches sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.history = nil;
}

#pragma mark -
#pragma mark Search

- (void)saveHistory {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[self.history allObjects] forKey:@"history"];
	[defaults synchronize];
}

- (void)saveSearch:(NSString *)search {
	self.searchTerm = search;
	[self.history addObject:search];
	[self saveHistory];
}

- (void)search:(NSString *)query {
	[self saveSearch:query];

	NSURL *searchURL = [NSURL URLWithString:[kSozlukURL stringByAppendingFormat:@"index.asp?a=sr&kw=%@", query]];

	EksiLinkController *linkController = [[EksiLinkController alloc] init];
	linkController.URL = searchURL;
	linkController.title = query;

	[self.navigationController pushViewController:linkController animated:YES];
	[linkController release];
}

- (void)go:(NSString *)query {
	NSURL *titleURL = [NSURL URLWithString:[kSozlukURL stringByAppendingFormat:@"/show.asp?t=%@", query]];

	EksiTitle *eksiTitle = [[EksiTitle alloc] init];
	eksiTitle.URL = titleURL;
	eksiTitle.title = query;

	TitleController *titleController = [[TitleController alloc] initWithEksiTitle:eksiTitle];
	[eksiTitle release];

	[self.navigationController pushViewController:titleController animated:YES];
	[titleController release];
}

@end
