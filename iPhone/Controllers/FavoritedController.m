//
//  FavoritedController.m
//  mayhos
//
//  Created by Can Berk Güder on 21/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritedController.h"
#import "UIViewController+ModalPickerView.h"

@implementation FavoritedController

@synthesize favoriteItem;
@synthesize activityItem;
@synthesize pagesItem;
@synthesize numberOfPages;
@synthesize currentPage;
@synthesize favorited;

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

	self.favoriteItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
	self.favoriteItem.imageInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	favoriteItem.enabled = NO;
	[self.favoriteItem release];

	self.favorited = favorited;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [UIAppDelegatePhone shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Accessors

- (void)setFavorited:(BOOL)theFavorited {
	favorited = theFavorited;

	if(favorited) {
		self.favoriteItem.image = [UIImage imageNamed:@"Star.png"];
	} else {
		self.favoriteItem.image = [UIImage imageNamed:@"Star-Hollow.png"];
	}
}

- (void)resetPagesItem {
	if (numberOfPages > 1) {
		pagesItem.title = [NSString stringWithFormat:@"%d/%d", currentPage, numberOfPages];
		self.navigationItem.rightBarButtonItem = pagesItem;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)setNumberOfPages:(NSUInteger)number {
	numberOfPages = number;
	[self resetPagesItem];
}

- (void)setCurrentPage:(NSUInteger)number {
	currentPage = number;
	[self resetPagesItem];
}

#pragma mark -

- (void)pagesClicked {
	PagePickerView *pagePicker = [[PagePickerView alloc] init];
	pagePicker.delegate = self;
	pagePicker.numberOfPages = numberOfPages;
	pagePicker.currentPage = currentPage;
	[self presentModalPickerView:pagePicker];
	[pagePicker release];
}

- (void)pagePicker:(PagePickerView *)pagePicker pickedPage:(NSUInteger)page {
	if(currentPage != page) {
		[self loadPage:page];
	}
}

- (void)loadPage:(NSUInteger)page {
}

- (void)favorite {
	self.favorited = !self.favorited;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[favoriteItem release];
	[activityItem release];
	[pagesItem release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.favoriteItem = nil;
	self.activityItem = nil;
	self.pagesItem = nil;
}

@end
