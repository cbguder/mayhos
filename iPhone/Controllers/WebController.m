//
//  WebController.m
//  mayhos
//
//  Created by Can Berk Güder on 10/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "WebController.h"

@implementation WebController

@synthesize currentURL, backItem, forwardItem, reloadItem, stopItem, actionItem, activityItem;

#pragma mark -
#pragma mark Initialization

- (id)init {
	return [self initWithURL:nil];
}

- (id)initWithURL:(NSURL *)URL {
	if(self = [super init]) {
		self.currentURL = URL;
	}

	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
	webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	self.view = webView;
	[webView release];
}

- (void)viewDidLoad {
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicatorView startAnimating];
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	[activityIndicatorView release];

	stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop)];

	NSMutableArray *items = [NSMutableArray arrayWithCapacity:9];

	UIBarButtonItem *space;

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	space.width = 12.0;
	[items addObject:space];
	[space release];

	self.backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	backItem.enabled = NO;
	[items addObject:backItem];
	[backItem release];

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	space.width = 40.0;
	[items addObject:space];
	[space release];

	self.forwardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
	forwardItem.enabled = NO;
	[items addObject:forwardItem];
	[forwardItem release];

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:space];
	[space release];

	self.reloadItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
	[items addObject:reloadItem];
	[reloadItem release];

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	space.width = 40.0;
	[items addObject:space];
	[space release];

	self.actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
	[items addObject:actionItem];
	[actionItem release];

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	space.width = 12.0;
	[items addObject:space];
	[space release];

	[self setToolbarItems:items];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[webView loadRequest:[NSURLRequest requestWithURL:currentURL]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[webView stopLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [UIAppDelegatePhone shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Toolbar

- (void)back {
	if([webView canGoBack])
		[webView goBack];
}

- (void)forward {
	if([webView canGoForward])
		[webView goForward];
}

- (void)reload {
	[webView reload];
}

- (void)stop {
	[webView stopLoading];
}

- (void)action {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[currentURL absoluteString]
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Open in Safari", nil];

	[actionSheet showFromToolbar:self.navigationController.toolbar];
	[actionSheet release];
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:currentURL];
	}
}

#pragma mark -
#pragma mark Web view delegate

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	self.currentURL = request.mainDocumentURL;
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self.navigationItem setRightBarButtonItem:activityItem];

	NSMutableArray *items = [self.toolbarItems mutableCopy];
	[items replaceObjectAtIndex:5 withObject:stopItem];
	self.toolbarItems = items;

	self.title = @"Loading...";
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self.navigationItem setRightBarButtonItem:nil];

	NSMutableArray *items = [self.toolbarItems mutableCopy];
	[items replaceObjectAtIndex:5 withObject:reloadItem];
	self.toolbarItems = items;

	backItem.enabled = [aWebView canGoBack];
	forwardItem.enabled = [aWebView canGoForward];
	self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	[self webViewDidFinishLoad:aWebView];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[webView setDelegate:nil];
	[currentURL release];

	[backItem release];
	[forwardItem release];
	[reloadItem release];
	[stopItem release];
	[actionItem release];
	[activityItem release];

	[super dealloc];
}

- (void)viewDidUnload {
	self.backItem = nil;
	self.forwardItem = nil;
	self.reloadItem = nil;
	self.stopItem = nil;
	self.actionItem = nil;
	self.activityItem = nil;
}

@end
