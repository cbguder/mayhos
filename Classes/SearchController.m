//
//  SearchController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "SearchController.h"

@implementation SearchController

#pragma mark Accessors

@synthesize mySearchBar;

#pragma mark UISearchBarDelegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];

	[stories removeAllObjects];
	[myTableView reloadData];

	NSString *query = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSString *searchURL = [NSString stringWithFormat:@"http://sozluk.sourtimes.org/index.asp?a=sr&kw=%@", query];
	NSString *directURL = [NSString stringWithFormat:@"http://sozluk.sourtimes.org/show.asp?t=%@", query];

	activeConnections = 2;

	[myURL release];
	myURL = [[NSURL alloc] initWithString:searchURL];
	[self loadURL];

	EksiTitle *title = [[EksiTitle alloc] init];
	[title setURL:[NSURL URLWithString:directURL]];
	[title setDelegate:self];
	[title loadEntries];
}

#pragma mark NSURLConnectionDelegate Methods

- (void)decrementActiveConnections {
	@synchronized(self) {
		activeConnections--;

		if(activeConnections == 0) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			[self.navigationItem setRightBarButtonItem:nil];
			[myTableView reloadData];
		} else {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			[self.navigationItem setRightBarButtonItem:activityItem];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[super connection:connection didFailWithError:error];
	[self decrementActiveConnections];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
	[parser setDelegate:self];
	[parser parse];

	[responseData release];
	[connection release];
	[parser release];

	[self decrementActiveConnections];
}

- (void)title:(EksiTitle*)title didFailLoadingEntriesWithError:(NSError *)error {
	[self decrementActiveConnections];
}

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	if([title.entries count] != 0) {
		EksiEntry *firstEntry = [title.entries objectAtIndex:0];
		if(firstEntry.author != nil) {
			[stories insertObject:title atIndex:0];
		}
	}

	[self decrementActiveConnections];
}

@end
