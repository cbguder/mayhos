//
//  RightFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RightFrameController.h"
#import "LeftFrameController.h"
#import "ModalWebController.h"
#import "FavoritesManager.h"
#import "EksiEntry.h"
#import "NSURL+Query.h"

#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@interface RightFrameController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *tumuItem;
@property (nonatomic, retain) UIBarButtonItem *favoriteItem;
@property (nonatomic, retain) MGTemplateEngine *templateEngine;
@property (nonatomic, copy) NSString *HTMLTemplate;
@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, assign) BOOL favorited;

- (UIViewController *)leftFrameController;
- (void)resetToolbar;
@end

@implementation RightFrameController

@synthesize popoverController;
@synthesize tumuItem;
@synthesize favoriteItem;
@synthesize templateEngine;
@synthesize HTMLTemplate;
@synthesize baseURL;
@synthesize eksiTitle;
@synthesize favorited;

#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		self.templateEngine = [MGTemplateEngine templateEngine];
		templateEngine.matcher = [ICUTemplateMatcher matcherWithTemplateEngine:templateEngine];

		NSBundle *bundle = [NSBundle mainBundle];
		NSString *templatePath = [bundle pathForResource:@"title" ofType:@"html"];
		self.HTMLTemplate = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];

		self.baseURL = [NSURL fileURLWithPath:[bundle bundlePath]];
	}

	return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setEksiTitle:(EksiTitle *)anEksiTitle {
	if (eksiTitle != anEksiTitle) {
		[eksiTitle setDelegate:nil];
		[eksiTitle release];

		favoriteItem.enabled = NO;
		tumuItem.enabled = NO;

		eksiTitle = [anEksiTitle retain];
		[eksiTitle setDelegate:self];
		[eksiTitle loadEntries];
	}
}
- (void)setFavorited:(BOOL)theFavorited {
	favorited = theFavorited;

	if (favorited) {
		self.favoriteItem.image = [UIImage imageNamed:@"Star.png"];
	} else {
		self.favoriteItem.image = [UIImage imageNamed:@"Star-Hollow.png"];
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

	self.tumuItem = [[UIBarButtonItem alloc] initWithTitle:@"tümünü göster"
													 style:UIBarButtonItemStyleBordered
													target:self
													action:@selector(tumunuGoster)];
	[tumuItem release];

	self.favoriteItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Star-Hollow.png"]
														 style:UIBarButtonItemStylePlain
														target:self
														action:@selector(favorite)];
	favoriteItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
	[favoriteItem release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Web view delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([request.URL.scheme isEqualToString:@"file"]) {
		return YES;
	}

	if ([request.URL.scheme isEqualToString:@"mayhos"]) {
		NSString *rest = [request.URL.absoluteString substringFromIndex:8];
		NSURL *realURL = [API URLForPath:rest];

		if ([rest hasPrefix:@"/show.asp"]) {
			// Change right frame

			NSString *titleText = [[realURL queryDictionary] objectForKey:@"t"];
			self.eksiTitle = [EksiTitle titleWithTitle:titleText URL:realURL];

			UIViewController *leftFrameController = [self leftFrameController];
			if ([leftFrameController respondsToSelector:@selector(tableView)]) {
				UITableView *tableView = ((UITableViewController *)leftFrameController).tableView;
				[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
			}
		} else if ([rest hasPrefix:@"/index.asp"]) {
			// Change left frame

			NSString *query = [[realURL queryDictionary] objectForKey:@"kw"];

			LeftFrameController *leftFrameController = [[LeftFrameController alloc] init];
			leftFrameController.title = query;
			leftFrameController.URL = realURL;

			UINavigationController *leftNavigationController = [self.splitViewController.viewControllers objectAtIndex:0];
			[leftNavigationController pushViewController:leftFrameController animated:YES];
			[leftFrameController release];
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
	if ([aViewController isKindOfClass:[UINavigationController class]]) {
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
	self.favorited = [[FavoritesManager sharedManager] hasFavoriteForTitle:eksiTitle.title];
	favoriteItem.enabled = YES;
	tumuItem.enabled = YES;

	[self resetToolbar];

	NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithObject:title.entries forKey:@"entries"];

	if ([title isEmpty]) {
		NSString *message;
		if ([title.entries count]) {
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
	favoriteItem.enabled = YES;
	tumuItem.enabled = YES;
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.popoverController = nil;
	self.tumuItem = nil;
	self.favoriteItem = nil;
}

- (void)dealloc {
	[popoverController release];
	[tumuItem release];
	[favoriteItem release];
	[templateEngine release];
	[HTMLTemplate release];
	[baseURL release];
	[super dealloc];
}

#pragma mark -

- (UIViewController *)leftFrameController {
	UIViewController *foo = [self.splitViewController.viewControllers objectAtIndex:0];
	if ([foo isKindOfClass:[UINavigationController class]]) {
		return ((UINavigationController *)foo).topViewController;
	} else {
		return foo;
	}
}

- (void)loadPage:(NSUInteger)page {
	[self.eksiTitle loadPage:page];
}

- (void)tumunuGoster {
	if ([self.eksiTitle hasMoreToLoad]) {
		[self.eksiTitle loadAllEntries];
	}
}

- (void)favorite {
	if (favorited) {
		[[FavoritesManager sharedManager] deleteFavoriteForTitle:eksiTitle.title];
	} else {
		[[FavoritesManager sharedManager] createFavoriteForTitle:eksiTitle.title];
	}

	self.favorited = !self.favorited;
}

- (void)resetToolbar {
	NSMutableArray *items = [NSMutableArray array];
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:flexibleSpace];

	if ([self.eksiTitle hasMoreToLoad]) {
		[items addObject:tumuItem];
		[items addObject:flexibleSpace];
	}

	[items addObject:favoriteItem];

	[flexibleSpace release];
	self.toolbarItems = items;
}

@end
