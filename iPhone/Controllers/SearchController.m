//
//  SearchController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "SearchController.h"
#import "AdvancedSearchController.h"
#import "HistoryManager.h"

@interface SearchController (Private)
- (void)search:(NSString *)query;
@end

@implementation SearchController

@synthesize matches, advancedSearchItem;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.advancedSearchItem = [[UIBarButtonItem alloc] initWithTitle:@"hayvan ara" style:UIBarButtonItemStyleBordered target:self action:@selector(advancedSearch)];
	[self.advancedSearchItem release];

	self.navigationItem.leftBarButtonItem = self.advancedSearchItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [UIAppDelegatePhone shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		return [self.matches count];
	}

	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	cell.textLabel.text = [self.matches objectAtIndex:indexPath.row];

	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		[[HistoryManager sharedManager] removeString:[self.matches objectAtIndex:indexPath.row]];
		[self.matches removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self search:[self.matches objectAtIndex:indexPath.row]];
}

#pragma mark -
#pragma mark Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self search:searchBar.text];
}

#pragma mark -
#pragma mark Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@", [NSString stringWithFormat:@"*%@*", searchString]];
	self.matches = [NSMutableArray arrayWithArray:[[HistoryManager sharedManager].history allObjects]];
	[self.matches filterUsingPredicate:predicate];
	[self.matches sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[advancedSearchItem release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.advancedSearchItem = nil;
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Search

- (void)search:(NSString *)query {
	[[HistoryManager sharedManager] addString:query];

	if(self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
		EksiTitle *eksiTitle = [EksiTitle titleWithTitle:query URL:[API URLForTitle:query]];
		TitleController *titleController = [[TitleController alloc] initWithEksiTitle:eksiTitle];
		[self.navigationController pushViewController:titleController animated:YES];
		[titleController release];
	} else {
		EksiLinkController *linkController = [[EksiLinkController alloc] init];
		linkController.URL = [API URLForSearchQuery:query];
		linkController.title = query;

		[self.navigationController pushViewController:linkController animated:YES];
		[linkController release];
	}
}

- (void)advancedSearch {
	AdvancedSearchController *advancedSearchController = [[AdvancedSearchController alloc] initWithStyle:UITableViewStyleGrouped];

	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:advancedSearchController];
	[self presentModalViewController:navigationController animated:YES];

	[advancedSearchController release];
	[navigationController release];
}

@end
