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
	searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	if(![searchBar.text isEqual:@""]) {
		NSString *url = @"http://sozluk.sourtimes.org/index.asp?a=sr&kw=";
		url = [url stringByAppendingString:[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1254StringEncoding]];
		myURL = [[NSURL alloc] initWithString:url];
		NSURLRequest *request =	[NSURLRequest requestWithURL:myURL];
		myConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

@end

