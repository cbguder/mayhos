//
//  WebController.m
//  mayhos
//
//  Created by Can Berk Güder on 10/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "WebController.h"

@implementation WebController

@synthesize webView, currentURL, toolbar, backItem, forwardItem, reloadItem, actionItem, activityItem;

- (id)init {
	return [self initWithURL:nil];
}

- (id)initWithURL:(NSURL *)URL {
	if(self = [super initWithNibName:@"Web" bundle:nil]) {
		UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[activityIndicatorView startAnimating];
		activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
		[activityIndicatorView release];

		self.currentURL = URL;
	}

	return self;	
}

- (void)viewDidAppear:(BOOL)animated {
	[webView loadRequest:[NSURLRequest requestWithURL:currentURL]];
}

- (void)dealloc {
	[webView release];
	[currentURL release];

	[toolbar release];
	[backItem release];
	[forwardItem release];
	[reloadItem release];
	[actionItem release];
	[activityItem release];

	[super dealloc];
}

- (void)showActionSheet:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[currentURL absoluteString]
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Open in Safari", nil];

	[actionSheet showInView:self.view.window];
}

#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:currentURL];
	}
}

#pragma mark UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	self.currentURL = request.mainDocumentURL;
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	NSMutableArray *newItems = [toolbar.items mutableCopy];
	[newItems replaceObjectAtIndex:4 withObject:activityItem];
	[toolbar setItems:newItems];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	backItem.enabled = [aWebView canGoBack];
	forwardItem.enabled = [aWebView canGoForward];

	NSMutableArray *newItems = [toolbar.items mutableCopy];
	[newItems replaceObjectAtIndex:4 withObject:reloadItem];
	[toolbar setItems:newItems];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	[self webViewDidFinishLoad:aWebView];
}

@end
