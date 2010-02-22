//
//  WebController.m
//  mayhos
//
//  Created by Can Berk Güder on 10/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "WebController.h"

@interface WebController (Private)
- (void)back:(id)sender;
- (void)forward:(id)sender;
- (void)reload:(id)sender;
- (void)stop:(id)sender;
- (void)action:(id)sender;
@end


@implementation WebController

@synthesize currentURL, backItem, forwardItem, reloadItem, stopItem, actionItem, activityItem;

- (id)init {
	return [self initWithURL:nil];
}

- (id)initWithURL:(NSURL *)URL {
	if(self = [super init]) {
		self.currentURL = URL;
	}

	return self;
}

- (void)loadView {
	webView = [[UIWebView alloc] init];
	self.view = webView;
	[webView release];
}

- (void)viewDidLoad {
	[webView setScalesPageToFit:YES];
	[webView setDelegate:self];

	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicatorView startAnimating];
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	[activityIndicatorView release];

	stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop:)];

	NSMutableArray *items = [NSMutableArray arrayWithCapacity:9];

	UIBarButtonItem *space;

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	space.width = 12.0;
	[items addObject:space];
	[space release];

	self.backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
	backItem.enabled = NO;
	[items addObject:backItem];
	[backItem release];

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	space.width = 40.0;
	[items addObject:space];
	[space release];

	self.forwardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forward:)];
	forwardItem.enabled = NO;
	[items addObject:forwardItem];
	[forwardItem release];

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:space];
	[space release];

	self.reloadItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
	[items addObject:reloadItem];
	[reloadItem release];

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	space.width = 40.0;
	[items addObject:space];
	[space release];

	self.actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
	[items addObject:actionItem];
	[actionItem release];

	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	space.width = 12.0;
	[items addObject:space];
	[space release];

	[self.navigationController setToolbarHidden:NO animated:YES];
	[self setToolbarItems:items];
}

- (void)viewDidAppear:(BOOL)animated {
	[webView loadRequest:[NSURLRequest requestWithURL:currentURL]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setToolbarHidden:YES animated:YES];
	[webView stopLoading];
}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark Toolbar Buttons

- (void)back:(id)sender {
	if([webView canGoBack])
		[webView goBack];
}

- (void)forward:(id)sender {
	if([webView canGoForward])
		[webView goForward];
}

- (void)reload:(id)sender {
	[webView reload];
}

- (void)stop:(id)sender {
	[webView stopLoading];
}

- (void)action:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[currentURL absoluteString]
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Open in Safari", nil];

	[actionSheet showFromToolbar:self.navigationController.toolbar];
	[actionSheet release];
}

#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:currentURL];
	}
}

#pragma mark UIWebViewDelegate Methods

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

@end
