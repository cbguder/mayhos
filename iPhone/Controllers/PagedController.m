//
//  PagedController.m
//  mayhos
//
//  Created by Can Berk Güder on 11/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "PagedController.h"
#import "UIViewController+ModalPickerView.h"

@implementation PagedController

@synthesize activityItem, pagesItem;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.pagesItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(pagesClicked)];
	[pagesItem release];

	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicatorView startAnimating];
	self.activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	[activityIndicatorView release];
	[activityItem release];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self resetNavigationBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [UIAppDelegatePhone shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return pages;
}

#pragma mark -
#pragma mark Picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%d", row + 1];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[activityItem release];
	[pagesItem release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.activityItem = nil;
	self.pagesItem = nil;
}

#pragma mark -

- (void)resetNavigationBar {
	if(pages > 1) {
		[pagesItem setTitle:[NSString stringWithFormat:@"%d/%d", currentPage, pages]];
		[self.navigationItem setRightBarButtonItem:pagesItem];
	} else {
		[self.navigationItem setRightBarButtonItem:nil];
	}
}

- (void)pagesClicked {
	PagePickerView *pagePicker = [[PagePickerView alloc] init];
	[pagePicker setDelegate:self];
	[pagePicker setSelectedPage:currentPage];
	[self presentModalPickerView:pagePicker];
	[pagePicker release];
}

- (void)pagePicker:(PagePickerView *)pagePicker pickedPage:(NSInteger)page {
	if(currentPage != page) {
		[self loadPage:page];
	}
}

- (void)loadPage:(NSUInteger)page {
}

- (void)finishedLoadingPage {
	[self resetNavigationBar];
}

@end
