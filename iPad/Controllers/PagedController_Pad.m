//
//  PagedController_Pad.m
//  mayhos
//
//  Created by Can Berk Güder on 31/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "PagedController_Pad.h"
#import "PagePickerController.h"

@interface PagedController_Pad ()
@property (nonatomic,assign) NSUInteger pages;
@property (nonatomic,assign) NSUInteger currentPage;
@property (nonatomic,retain) UIBarButtonItem *pagesItem;
@property (nonatomic,retain) UIPopoverController *pagesPopover;
@end

@implementation PagedController_Pad

@synthesize pages, currentPage, pagesItem, pagesPopover;

- (void)setPagesItemTitle {
	self.pagesItem.title = [NSString stringWithFormat:@"%d/%d", currentPage, pages];
}

- (void)setPages:(NSUInteger)thePages {
	pages = thePages;
	[self setPagesItemTitle];

	if(pages > 1) {
		self.navigationItem.rightBarButtonItem = self.pagesItem;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)setCurrentPage:(NSUInteger)theCurrentPage {
	currentPage = theCurrentPage;
	[self setPagesItemTitle];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.pagesItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(pagesClicked)];
	[pagesItem release];
	[self setPagesItemTitle];

	PagePickerController *pagePicker = [[PagePickerController alloc] initWithDelegate:self];
	self.pagesPopover = [[UIPopoverController alloc] initWithContentViewController:pagePicker];
	[pagesPopover release];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if(pagesPopover.popoverVisible) {
		[pagesPopover dismissPopoverAnimated:YES];
	}
}

#pragma mark -
#pragma mark Parser delegate

- (void)parserDidFinishParsing:(EksiParser *)parser {
	self.currentPage = parser.currentPage;
	self.pages = parser.pages;
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	[parser release];
}

#pragma mark -
#pragma mark Page picker delegate

- (void)pagePicker:(PagePickerController *)pagePicker pickedPage:(NSUInteger)page {
	[pagesPopover dismissPopoverAnimated:YES];
	[self loadPage:page];
}

#pragma mark -

- (void)pagesClicked {
	if(pagesPopover.popoverVisible) {
		[pagesPopover dismissPopoverAnimated:YES];
	} else {
		PagePickerController *pagePickerController = (PagePickerController *)pagesPopover.contentViewController;
		pagePickerController.currentPage = currentPage;
		pagePickerController.totalPages = pages;
		[pagesPopover presentPopoverFromBarButtonItem:self.pagesItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (void)loadPage:(NSUInteger)page {
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	[super viewDidUnload];
	self.pagesItem = nil;
	self.pagesPopover = nil;
}

- (void)dealloc {
	[pagesItem release];
	[pagesPopover release];
	[super dealloc];
}

@end
