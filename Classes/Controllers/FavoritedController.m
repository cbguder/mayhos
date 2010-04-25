//
//  FavoritedController.m
//  mayhos
//
//  Created by Can Berk Güder on 21/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritedController.h"

@implementation FavoritedController

@synthesize favoriteItem, favoriteItemEnabled, favorited;

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

- (void)setFavoriteItemEnabled:(BOOL)enabled {
	favoriteItemEnabled = enabled;
	self.favoriteItem.enabled = enabled;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.favoriteItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
	self.favoriteItemEnabled = self.favoriteItemEnabled;
	[self.favoriteItem release];

	self.favorited = favorited;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[favoriteItem release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.favoriteItem = nil;
}

#pragma mark -

- (void)favorite {
	self.favorited = !self.favorited;
}

@end
