//
//  EntryController.m
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "EntryController.h"
#import "EksiEntry.h"
#import "WebController.h"
#import "TitleController.h"
#import "EksiLinkController.h"
#import "NSURL+Query.h"

#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@interface EntryController ()
@property (nonatomic, retain) MGTemplateEngine *templateEngine;

- (void)refreshViewContent;
@end

@implementation EntryController

@synthesize templateEngine;

#pragma mark -
#pragma mark Initialization

- (id)initWithEksiTitle:(EksiTitle *)theTitle index:(NSUInteger)theIndex {
	if ((self = [super initWithNibName:nil bundle:nil])) {
		eksiTitle = [theTitle retain];
		index = theIndex;

		self.templateEngine = [MGTemplateEngine templateEngine];
		templateEngine.matcher = [ICUTemplateMatcher matcherWithTemplateEngine:templateEngine];

		NSBundle *bundle = [NSBundle mainBundle];
		NSString *templatePath = [bundle pathForResource:@"entry" ofType:@"html"];
		entryTemplate = [[NSString alloc] initWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:NULL];

		baseURL = [[NSURL fileURLWithPath:[bundle bundlePath]] retain];
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
	webView.dataDetectorTypes = UIDataDetectorTypeNone;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	UIImage *up = [UIImage imageNamed:@"Up.png"];
	UIImage *down = [UIImage imageNamed:@"Down.png"];

	upDownControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:up, down, nil]];
	upDownControl.segmentedControlStyle = UISegmentedControlStyleBar;
	upDownControl.momentary = YES;
	[upDownControl setWidth:45 forSegmentAtIndex:0];
	[upDownControl setWidth:45 forSegmentAtIndex:1];
	[upDownControl addTarget:self action:@selector(upDown:) forControlEvents:UIControlEventValueChanged];

	UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:upDownControl];
	[self.navigationItem setRightBarButtonItem:bar];
	[bar release];

	[self refreshViewContent];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if (![self.navigationController.viewControllers containsObject:self]) {
		UIViewController *topViewController = self.navigationController.topViewController;

		if ([topViewController isMemberOfClass:[TitleController class]]) {
			UITableView *tableView = (UITableView *)topViewController.view;
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

			@try {
				[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
				[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			} @catch (NSException * e) {
				;
			}
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [UIAppDelegatePhone shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
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
			NSString *titleText = [[realURL queryDictionary] objectForKey:@"t"];

			EksiTitle *title = [EksiTitle titleWithTitle:titleText URL:realURL];
			TitleController *titleController = [[TitleController alloc] initWithEksiTitle:title];
			[self.navigationController pushViewController:titleController animated:YES];
			[titleController release];
		} else if ([rest hasPrefix:@"/index.asp"]) {
			NSString *query = [[realURL queryDictionary] objectForKey:@"kw"];

			EksiLinkController *linkController = [[EksiLinkController alloc] init];
			linkController.title = query;
			linkController.URL = realURL;

			[self.navigationController pushViewController:linkController animated:YES];
			[linkController release];
		}
	} else {
		WebController *webController = [[WebController alloc] initWithURL:request.URL];
		[self.navigationController pushViewController:webController animated:YES];
		[webController release];
	}

	return NO;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[templateEngine release];
	[entryTemplate release];
	[upDownControl release];
	[eksiTitle release];
	[baseURL release];
	[super dealloc];
}

#pragma mark -

- (void)refreshViewContent {
	NSUInteger entryCount = [eksiTitle.entries count];

	if (index >= entryCount) return;

	EksiEntry *entry = [eksiTitle.entries objectAtIndex:index];

	self.title = [NSString stringWithFormat:@"#%d", entry.order];

	if (upDownControl.numberOfSegments == 2) {
		[upDownControl setEnabled:(index != 0) forSegmentAtIndex:0];
		[upDownControl setEnabled:(index+1 != entryCount) forSegmentAtIndex:1];
	}

	if (webView) {
		NSDictionary *variables = [NSDictionary dictionaryWithObject:entry forKey:@"entry"];
		NSString *htmlString = [templateEngine processTemplate:entryTemplate withVariables:variables];
		[webView loadHTMLString:htmlString baseURL:baseURL];
	}
}

- (void)upDown:(id)sender {
	UISegmentedControl *control = sender;

	switch(control.selectedSegmentIndex) {
		case 0:
			index--;
			break;
		case 1:
			index++;
			break;
	}

	[self refreshViewContent];
}

@end
