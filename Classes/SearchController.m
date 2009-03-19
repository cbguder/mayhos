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

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[super connection:connection didFailWithError:error];
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[super connectionDidFinishLoading:connection];
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
}

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
	[myURL release];
	[myConnection release];

	[searchBar resignFirstResponder];

	[self.navigationItem setRightBarButtonItem:activityItem animated:YES];

	NSString *url = @"http://sozluk.sourtimes.org/index.asp?a=sr&kw=";
	url = [url stringByAppendingString:[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	myURL = [[NSURL alloc] initWithString:url];
	NSURLRequest *request =	[NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
	myConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
