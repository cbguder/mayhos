//
//  PagedController.m
//  mayhos
//
//  Created by Can Berk Güder on 11/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "PagedController.h"

@implementation PagedController

@synthesize activityItem, pagesItem;

- (void)dealloc {
	[activityItem release];
	[pagesItem release];
	[super dealloc];
}

#pragma mark UIViewController Methods

- (void)viewDidLoad {
	self.pagesItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(pagesClicked:)];
	[pagesItem release];

	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicatorView startAnimating];
	self.activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	[activityIndicatorView release];
	[activityItem release];
}

- (void)viewDidAppear:(BOOL)animated {
	[self resetNavigationBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark Other Methods

- (void)pagesClicked:(id)sender {
	CGRect initialFrame;
	CGRect finalFrame;

	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate lockOrientation:self.interfaceOrientation];

	if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
		initialFrame = CGRectMake(0, 260, 320, 480);
		finalFrame = CGRectMake(0, 0, 320, 480);
	} else {
		initialFrame = CGRectMake(0, 206, 480, 320);
		finalFrame = CGRectMake(0, 0, 480, 320);
	}

	mayhosAppDelegate *appDelegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	UIView *parentView = appDelegate.tabBarController.view;

	PagePickerView *pagePicker = [[PagePickerView alloc] initWithFrame:initialFrame];
	[pagePicker setDelegate:self];
	[pagePicker setSelectedPage:currentPage];
	[parentView addSubview:pagePicker];
	[pagePicker release];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[pagePicker setFrame:finalFrame];
	[UIView commitAnimations];
}

- (void)resetNavigationBar {
	if(pages > 1) {
		[pagesItem setTitle:[NSString stringWithFormat:@"%d/%d", currentPage, pages]];
		[self.navigationItem setRightBarButtonItem:pagesItem];
	} else {
		[self.navigationItem setRightBarButtonItem:nil];
	}
}

- (void)loadPage:(NSUInteger)page {
}

- (void)finishedLoadingPage {
	[self resetNavigationBar];
}

#pragma mark PagePickerDelegate Methods

- (void)pagePicked:(NSInteger)page {
	if(currentPage != page) {
		[self loadPage:page];
	}
}

#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return pages;
}

#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%d", row + 1];
}

@end
