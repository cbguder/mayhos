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

	NSString *url = @"http://sozluk.sourtimes.org/index.asp?a=sr&kw=";
	url = [url stringByAppendingString:[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

	[myURL release];
	myURL = [[NSURL alloc] initWithString:url];

	[self loadURL];
}

@end
