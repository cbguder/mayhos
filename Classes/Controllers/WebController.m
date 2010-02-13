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
		self.currentURL = URL;
	}

	return self;	
}

- (void)viewDidLoad {
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicatorView startAnimating];
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	[activityIndicatorView release];
}

- (void)viewDidAppear:(BOOL)animated {
	[webView loadRequest:[NSURLRequest requestWithURL:currentURL]];
}

- (void)dealloc {
	webView.delegate = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)showActionSheet:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[currentURL absoluteString]
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Open in Safari", nil];

	mayhosAppDelegate *appDelegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	UIView *parentView = appDelegate.tabBarController.view;
	[actionSheet showInView:parentView];
	[actionSheet release];
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
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self.navigationItem setRightBarButtonItem:activityItem];
	self.title = @"Loading...";
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	backItem.enabled = [aWebView canGoBack];
	forwardItem.enabled = [aWebView canGoForward];
	self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];

	[self.navigationItem setRightBarButtonItem:nil];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	[self webViewDidFinishLoad:aWebView];
}

@end
