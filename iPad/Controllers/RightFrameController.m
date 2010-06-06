//
//  RightFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RightFrameController.h"
#import "ModalWebController.h"
#import "EksiEntry.h"
#import "NSURL+Query.h"

#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@interface RightFrameController ()
@property (nonatomic,retain) UIPopoverController *popoverController;
@property (nonatomic,retain) MGTemplateEngine *templateEngine;
@property (nonatomic,copy) NSString *HTMLTemplate;
@property (nonatomic,retain) NSURL *baseURL;

- (UIViewController *)leftFrameController;
@end

@implementation RightFrameController

@synthesize popoverController, templateEngine, HTMLTemplate, baseURL, eksiTitle;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *templatePath = [bundle pathForResource:@"title" ofType:@"html"];
		self.templateEngine = [MGTemplateEngine templateEngine];
		templateEngine.matcher = [ICUTemplateMatcher matcherWithTemplateEngine:templateEngine];
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

- (void)loadView {
	webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	self.view = webView;
	[webView release];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	webView.delegate = self;
	webView.dataDetectorTypes = UIDataDetectorTypeNone;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	self.eksiTitle = [EksiTitle titleWithTitle:@"" URL:[API newsURL]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Web view delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if([request.URL.scheme isEqualToString:@"file"]) {
		return YES;
	}

	if([request.URL.scheme isEqualToString:@"mayhos"]) {
		NSString *rest = [request.URL.absoluteString substringFromIndex:9];
		NSURL *realURL = [NSURL URLWithString:[kSozlukURL stringByAppendingString:rest]];

		if([rest hasPrefix:@"show.asp"]) {
			NSString *titleText = [[[realURL queryDictionary] objectForKey:@"t"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
			self.eksiTitle = [EksiTitle titleWithTitle:titleText URL:realURL];

			UIViewController *leftFrameController = [self leftFrameController];
			if([leftFrameController respondsToSelector:@selector(tableView)]) {
				UITableView *tableView = ((UITableViewController *)leftFrameController).tableView;
				[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
			}
		} else if([rest hasPrefix:@"index.asp"]) {
			// TODO: Change left frame
		}
	} else {
		// Show web browser
		ModalWebController *modalWebController = [[ModalWebController alloc] initWithURL:request.URL];
		[self presentModalViewController:modalWebController animated:YES];
		[modalWebController release];
	}

	return NO;
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
	if([aViewController isKindOfClass:[UINavigationController class]]) {
		barButtonItem.title = ((UINavigationController *)aViewController).topViewController.title;
	} else {
		barButtonItem.title = aViewController.title;
	}

	self.navigationItem.leftBarButtonItem = barButtonItem;
	self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	self.navigationItem.leftBarButtonItem = nil;
	self.popoverController = nil;
}

#pragma mark -
#pragma mark Title delegate

- (void)titleDidFinishLoadingEntries:(EksiTitle *)title {
	self.title = title.title;
	self.pages = title.pages;
	self.currentPage = title.currentPage;

	NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithObject:title.entries forKey:@"entries"];

	if([title isEmpty]) {
		NSString *message;
		if([title.entries count]) {
			EksiEntry *firstEntry = [title.entries objectAtIndex:0];
			message = firstEntry.plainTextContent;
		} else {
			message = @"olmaması gereken şeyler oldu.";
		}

		[variables setObject:message forKey:@"errorMessage"];
	}

	NSString *result = [templateEngine processTemplate:self.HTMLTemplate withVariables:variables];
	[webView loadHTMLString:result baseURL:baseURL];
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
	[templateEngine release];
	[HTMLTemplate release];
	[baseURL release];
	[super dealloc];
}

#pragma mark -

- (UIViewController *)leftFrameController {
	UIViewController *foo = [self.splitViewController.viewControllers objectAtIndex:0];
	if([foo isKindOfClass:[UINavigationController class]]) {
		return ((UINavigationController *)foo).topViewController;
	} else {
		return foo;
	}
}

- (void)loadPage:(NSUInteger)page {
	[self.eksiTitle loadPage:page];
}

@end
