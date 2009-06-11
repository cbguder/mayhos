//
//  SearchController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "SearchController.h"

@implementation SearchController

@synthesize lastSearch, mySearchBar;

- (void)viewDidLoad {
	[super viewDidLoad];

	if(lastSearch != nil) {
		[mySearchBar setText:lastSearch];
	}
}

#pragma mark UISearchBarDelegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	searchBar.text = lastSearch;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];

	NSString *search = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if([search isEqualToString:@""]) {
		searchBar.text = lastSearch;
	} else {
		self.lastSearch = search;

		[stories removeAllObjects];
		[myTableView reloadData];

		NSString *query = [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

		NSString *searchURL = [NSString stringWithFormat:@"http://sozluk.sourtimes.org/index.asp?a=sr&kw=%@", query];
		NSString *directURL = [NSString stringWithFormat:@"http://sozluk.sourtimes.org/show.asp?t=%@", query];

		activeConnections = 2;

		myURL = [NSURL URLWithString:searchURL];
		[self loadURL];

		directSearchSuccess = NO;
		EksiTitle *title = [[EksiTitle alloc] init];
		[title setURL:[NSURL URLWithString:directURL]];
		[title setDelegate:self];
		[title loadEntries];
	}
}

- (void)decrementActiveConnections {
	@synchronized(self) {
		if(activeConnections > 0)
			activeConnections--;

		if(activeConnections == 0) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			[self.navigationItem setRightBarButtonItem:nil];

			if(directSearchSuccess && [stories count] > 1) {
				EksiTitle *firstTitle = (EksiTitle *)[stories objectAtIndex:0];
				for(int i = 1; i < [stories count]; i++) {
					EksiTitle *title = (EksiTitle *)[stories objectAtIndex:i];
					if([title.title isEqualToString:firstTitle.title]) {
						[stories removeObjectAtIndex:i];
						break;
					}
				}
			}

			[myTableView reloadData];
		} else {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
	[parser setDelegate:self];
	[parser parse];

	[responseData release];
	[connection release];
	myConnection = nil;
	[parser release];

	[self decrementActiveConnections];
}

#pragma mark EksiTitleDelegate Methods

- (void)title:(EksiTitle*)title didFailLoadingEntriesWithError:(NSError *)error {
	[self decrementActiveConnections];
	[title release];
}

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	if([[title entries] count] != 0) {
		EksiEntry *firstEntry = [[title entries] objectAtIndex:0];
		if(firstEntry.author != nil) {
			[stories insertObject:title atIndex:0];
			directSearchSuccess = YES;
		}
	}

	[self decrementActiveConnections];
	[title release];
}

@end
