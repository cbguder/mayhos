//
//  SearchController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "SearchController.h"

@implementation SearchController

@synthesize savedSearchTerm, savedScopeButtonIndex, searchWasActive;

- (void)viewDidLoad {
	[super viewDidLoad];

	if(self.savedSearchTerm) {
		[self.searchDisplayController setActive:self.searchWasActive];
		[self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
		[self.searchDisplayController.searchBar setText:savedSearchTerm];
		self.savedSearchTerm = nil;
	}
}

- (void)viewDidUnload {
	self.searchWasActive = [self.searchDisplayController isActive];
	self.savedSearchTerm = [self.searchDisplayController.searchBar text];
	self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

#pragma mark UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];

	NSString *search = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if([search isEqualToString:@""]) {
		[searchBar setText:@""];
	} else {
		[titles removeAllObjects];
		[[self searchDisplayController].searchResultsTableView reloadData];

		NSString *query = [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

		NSString *searchURL = [kSozlukURL stringByAppendingFormat:@"index.asp?a=sr&kw=%@", query];
		NSString *directURL = [kSozlukURL stringByAppendingFormat:@"show.asp?t=%@", query];

		activeConnections = 2;

		self.URL = [NSURL URLWithString:searchURL];
		[self loadURL];

		directSearchSuccess = NO;
		directTitle = [[EksiTitle alloc] init];
		[directTitle setURL:[NSURL URLWithString:directURL]];
		[directTitle setDelegate:self];
		[directTitle loadEntries];
	}
}

- (void)decrementActiveConnections {
	@synchronized(self) {
		if(activeConnections > 0)
			activeConnections--;

		if(activeConnections == 0) {
			[self.navigationItem setRightBarButtonItem:nil];

			if(directSearchSuccess && [titles count] > 0) {
				for(EksiTitle *title in titles) {
					if([title.title isEqualToString:directTitle.title]) {
						[titles removeObject:title];
						break;
					}
				}

				[titles insertObject:directTitle atIndex:0];
				[directTitle release];
				directSearchSuccess = NO;
				directTitle = nil;
			}

			[[self searchDisplayController].searchResultsTableView reloadData];
		} else {
			[self.navigationItem setRightBarButtonItem:activityItem];
		}
	}
}

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[super connection:connection didFailWithError:error];
	[self decrementActiveConnections];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[super connectionDidFinishLoading:connection];
	[self decrementActiveConnections];
}

#pragma mark UISearchDisplayDelegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	return NO;
}

#pragma mark EksiParserDelegate Methods

- (void)parserDidFinishParsing:(EksiParser *)parser {
	[super parserDidFinishParsing:parser];
	[self decrementActiveConnections];
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	[super parser:parser didFailWithError:error];
	[self decrementActiveConnections];
}

#pragma mark EksiTitleDelegate Methods

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	if([title.entries count] != 0) {
		EksiEntry *firstEntry = [title.entries objectAtIndex:0];
		if(firstEntry.author != nil) {
			directSearchSuccess = YES;
		}
	}

	[self decrementActiveConnections];
}

- (void)title:(EksiTitle*)title didFailLoadingtitlesWithError:(NSError *)error {
	[title release];
	directTitle = nil;

	[self decrementActiveConnections];
}

@end
