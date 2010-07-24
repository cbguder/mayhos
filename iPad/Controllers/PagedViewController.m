//
//  PagedViewController.m
//  mayhos
//
//  Created by Can Berk Güder on 31/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "PagedViewController.h"
#import "PagePickerController.h"

@interface PagedViewController ()
@property (nonatomic,retain) UIBarButtonItem *pagesItem;
@property (nonatomic,retain) UIPopoverController *pagesPopover;
@end

@implementation PagedViewController

@synthesize pages, currentPage, pagesItem, pagesPopover;

- (void)setPagesItemTitle {
	self.pagesItem.title = [NSString stringWithFormat:@"%d/%d", currentPage, pages];
}

- (void)setPages:(NSUInteger)thePages {
	pages = thePages;

	if (pages > 1) {
		self.navigationItem.rightBarButtonItem = self.pagesItem;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}

	[self setPagesItemTitle];
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

	if (pagesPopover.popoverVisible) {
		[pagesPopover dismissPopoverAnimated:YES];
	}
}

#pragma mark -
#pragma mark Page picker delegate

- (void)pagePickerController:(PagePickerController *)pagePickerController pickedPage:(NSUInteger)page {
	[pagesPopover dismissPopoverAnimated:YES];
	[self loadPage:page];
}

#pragma mark -

- (void)pagesClicked {
	if (!pagesPopover.popoverVisible) {
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
