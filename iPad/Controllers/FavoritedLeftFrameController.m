//
//  FavoritedLeftFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 23/7/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritedLeftFrameController.h"
#import "FavoritesManager.h"

@implementation FavoritedLeftFrameController

@synthesize favoriteItem, favorited;

- (void)viewDidLoad {
	[super viewDidLoad];

	self.favoriteItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
	favoriteItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
	[favoriteItem release];

	self.favorited = favorited;

	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	self.toolbarItems = [NSArray arrayWithObjects:flexibleSpaceItem, favoriteItem, nil];
	[flexibleSpaceItem release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)setFavorited:(BOOL)theFavorited {
	favorited = theFavorited;

	if(favorited) {
		favoriteItem.image = [UIImage imageNamed:@"Star.png"];
	} else {
		favoriteItem.image = [UIImage imageNamed:@"Star-Hollow.png"];
	}
}

- (void)favorite {
	if(favorited) {
		[[FavoritesManager sharedManager] deleteFavoriteForURL:self.URL];
	} else {
		[[FavoritesManager sharedManager] createFavoriteForURL:self.URL withTitle:self.title];
	}

	self.favorited = !self.favorited;
}

- (void)parserDidFinishParsing:(EksiParser *)parser {
	[super parserDidFinishParsing:parser];
	self.favorited = [[FavoritesManager sharedManager] hasFavoriteForURL:URL];
}

- (void)viewDidUnload {
	self.favoriteItem = nil;
	self.toolbarItems = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[favoriteItem release];
	[super dealloc];
}

@end
