//
//  RightFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RightFrameController.h"
#import "EksiEntry.h"

@interface RightFrameController ()
@property (nonatomic,retain) UIPopoverController *popoverController;
@property (nonatomic,copy) NSString *HTMLTemplate;
@property (nonatomic,retain) NSURL *baseURL;
@end

@implementation RightFrameController

@synthesize toolbar, webView, popoverController, HTMLTemplate, baseURL, eksiTitle;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *templatePath = [bundle pathForResource:@"title" ofType:@"html"];
		self.HTMLTemplate = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];
		self.baseURL = [NSURL fileURLWithPath:[bundle bundlePath]];
	}

	return self;
}

- (void)setEksiTitle:(EksiTitle *)anEksiTitle {
	if(eksiTitle != anEksiTitle) {
		[eksiTitle setDelegate:nil];
		[eksiTitle release];

		eksiTitle = [anEksiTitle retain];
		[eksiTitle setDelegate:self];
		[eksiTitle loadEntries];
	}
}

#pragma mark -
#pragma mark View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
	if([aViewController isKindOfClass:[UINavigationController class]]) {
		barButtonItem.title = ((UINavigationController *)aViewController).topViewController.title;
	} else {
		barButtonItem.title = aViewController.title;
	}

	NSMutableArray *items = [[toolbar items] mutableCopy];
	[items insertObject:barButtonItem atIndex:0];
	[toolbar setItems:items animated:YES];
	[items release];
	self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	NSMutableArray *items = [[toolbar items] mutableCopy];
	[items removeObjectAtIndex:0];
	[toolbar setItems:items animated:YES];
	[items release];
	self.popoverController = nil;
}

#pragma mark -
#pragma mark Title delegate

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	NSMutableString *entries = [NSMutableString string];

	for(EksiEntry *entry in title.entries) {
		[entries appendFormat:@"<li><p>%@</p><p class='signature'>(%@)</p></li>", entry.content, [entry signature]];
	}

	NSString *body = [NSString stringWithFormat:HTMLTemplate, entries];
	[webView loadHTMLString:body baseURL:baseURL];
}

- (void)title:(EksiTitle*)title didFailWithError:(NSError *)error {
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.popoverController = nil;
}

- (void)dealloc {
	[popoverController release];
	[toolbar release];
	[webView release];
	[HTMLTemplate release];
	[baseURL release];
	[super dealloc];
}

@end

