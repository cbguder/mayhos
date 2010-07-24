//
//  ModalWebController.m
//  mayhos
//
//  Created by Can Berk Güder on 5/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "ModalWebController.h"

@implementation ModalWebController

@synthesize URL, toolbar, backItem, forwardItem, addressBar, webView;
@synthesize reloadStopButton, reloadStopMode;

#pragma mark -
#pragma mark Initialization

- (id)initWithURL:(NSURL *)theURL {
	if ((self = [super init])) {
		self.URL = theURL;
	}

	return self;
}

- (void)setURL:(NSURL *)theURL {
	if (URL != theURL) {
		[URL release];
		URL = [theURL retain];
		self.addressBar.text = [URL absoluteString];
	}
}

#pragma mark -
#pragma mark Accessors

- (void)setReloadStopMode:(ReloadStopMode)mode {
	reloadStopMode = mode;

	UIImage *image = nil;
	if (reloadStopMode == ReloadStopModeReload) {
		image = [UIImage imageNamed:@"AddressViewReload.png"];
	} else if (reloadStopMode == ReloadStopModeStop) {
		image = [UIImage imageNamed:@"AddressViewStop.png"];
	}

	[reloadStopButton setImage:image forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.reloadStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
	reloadStopButton.frame = CGRectMake(0, 0, 13, 15);
	addressBar.rightViewMode = UITextFieldViewModeUnlessEditing;
	addressBar.rightView = reloadStopButton;

	[reloadStopButton addTarget:self action:@selector(reloadStopClicked) forControlEvents:UIControlEventTouchUpInside];
	self.reloadStopMode = ReloadStopModeReload;

	[webView loadRequest:[NSURLRequest requestWithURL:URL]];
	addressBar.text = [URL absoluteString];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[webView stopLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:textField.text]]];
	return YES;
}

#pragma mark -
#pragma mark Web view delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	self.URL = request.mainDocumentURL;
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	self.reloadStopMode = ReloadStopModeStop;
	self.backItem.enabled = [self.webView canGoBack];
	self.forwardItem.enabled = [self.webView canGoForward];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.reloadStopMode = ReloadStopModeReload;
	self.backItem.enabled = [self.webView canGoBack];
	self.forwardItem.enabled = [self.webView canGoForward];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self webViewDidFinishLoad:self.webView];
}

#pragma mark -

- (void)close {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)reloadStopClicked {
	if (reloadStopMode == ReloadStopModeReload) {
		[webView reload];
	} else if (reloadStopMode == ReloadStopModeStop) {
		[webView stopLoading];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	[super viewDidUnload];
	self.reloadStopButton = nil;
}

- (void)dealloc {
	[URL release];
	[toolbar release];
	[backItem release];
	[forwardItem release];
	[addressBar release];
	[webView release];
	[reloadStopButton release];
	[super dealloc];
}

@end
