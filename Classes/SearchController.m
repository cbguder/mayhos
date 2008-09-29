//
//  SearchController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import "SearchController.h"

@implementation SearchController

@synthesize mySearchBar;

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
	url = [url stringByAppendingString:[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1254StringEncoding]];
	myURL = [[NSURL alloc] initWithString:url];
	NSURLRequest *request =	[NSURLRequest requestWithURL:myURL];
	myConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[super connection:connection didFailWithError:error];
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[super connectionDidFinishLoading:connection];
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
}


@end

