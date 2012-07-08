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
@property (nonatomic, retain) UIBarButtonItem *pagesItem;
@property (nonatomic, retain) UISegmentedControl *pagesControl;
@property (nonatomic, retain) UIPopoverController *pagesPopover;
@end

@implementation PagedViewController

@synthesize pages;
@synthesize currentPage;
@synthesize pagesItem;
@synthesize pagesControl;
@synthesize pagesPopover;

- (void)setPagesItemTitle {
	[self.pagesControl setTitle:[NSString stringWithFormat:@"%d/%d", currentPage, pages]
			  forSegmentAtIndex:1];
	[self.pagesControl setEnabled:(currentPage != 1)
				forSegmentAtIndex:0];
	[self.pagesControl setEnabled:(currentPage != pages)
				forSegmentAtIndex:2];

	[self.pagesControl sizeToFit];
}

- (void)setPagesItemStyle {
	if (self.navigationController.navigationBar.barStyle == UIBarStyleDefault) {
		[pagesControl setImage:[UIImage imageNamed:@"Previous.png"] forSegmentAtIndex:0];
		[pagesControl setImage:[UIImage imageNamed:@"Next.png"] forSegmentAtIndex:2];
	} else {
		[pagesControl setImage:[UIImage imageNamed:@"PreviousWhite.png"] forSegmentAtIndex:0];
		[pagesControl setImage:[UIImage imageNamed:@"NextWhite.png"] forSegmentAtIndex:2];
	}
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

	NSArray *items = [NSArray arrayWithObjects:@"", @"", @"", nil];

	self.pagesControl = [[[UISegmentedControl alloc] initWithItems:items] autorelease];
	self.pagesControl.segmentedControlStyle = UISegmentedControlStyleBar;
	self.pagesControl.momentary = YES;
	[self.pagesControl addTarget:self action:@selector(pagesClicked) forControlEvents:UIControlEventValueChanged];
	[self.pagesControl setWidth:35 forSegmentAtIndex:0];
	[self.pagesControl setWidth:35 forSegmentAtIndex:2];
	[self.pagesControl setContentOffset:CGSizeMake(0.0f, -1.0f) forSegmentAtIndex:0];
	[self.pagesControl setContentOffset:CGSizeMake(0.0f, -1.0f) forSegmentAtIndex:2];

	self.pagesItem = [[[UIBarButtonItem alloc] initWithCustomView:pagesControl] autorelease];
	[self setPagesItemTitle];

	PagePickerController *pagePicker = [[PagePickerController alloc] initWithDelegate:self];
	self.pagesPopover = [[UIPopoverController alloc] initWithContentViewController:pagePicker];
	[pagesPopover release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self setPagesItemStyle];
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
	NSInteger i = pagesControl.selectedSegmentIndex;

	if (i == 0) {
		[self loadPage:currentPage-1];
	} else if (i == 1) {
		if (!pagesPopover.popoverVisible) {
			PagePickerController *pagePickerController = (PagePickerController *)pagesPopover.contentViewController;
			pagePickerController.currentPage = currentPage;
			pagePickerController.totalPages = pages;
			[pagesPopover presentPopoverFromBarButtonItem:self.pagesItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	} else if (i == 2) {
		[self loadPage:currentPage+1];
	}
}

- (void)loadPage:(NSUInteger)page {
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	[super viewDidUnload];
	self.pagesItem = nil;
	self.pagesControl = nil;
	self.pagesPopover = nil;
}

- (void)dealloc {
	[pagesItem release];
	[pagesControl release];
	[pagesPopover release];
	[super dealloc];
}

@end
