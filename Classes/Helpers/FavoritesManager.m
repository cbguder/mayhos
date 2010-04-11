//
//  FavoritesManager.m
//  mayhos
//
//  Created by Can Berk Güder on 11/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritesManager.h"

static FavoritesManager *SharedManager = nil;

@interface FavoritesManager (Private)
- (NSDictionary *)favoriteForTitle:(NSString *)title;
@end

@implementation FavoritesManager

@synthesize favorites;

+ (FavoritesManager *)sharedManager {
	@synchronized(self) {
		if(SharedManager == nil) {
			SharedManager = [[self allocWithZone:NULL] init];
		}
	}

	return SharedManager;
}

- (id)init {
	if(self = [super init]) {
		favorites = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"favorites"]];
	}

	return self;
}

- (NSDictionary *)favoriteForTitle:(NSString *)title {
	NSMutableDictionary *favorite = [NSMutableDictionary dictionaryWithCapacity:2];
	[favorite setObject:[NSNumber numberWithUnsignedInt:FavoriteTypeTitle] forKey:@"type"];
	[favorite setObject:title forKey:@"title"];

	return favorite;
}

- (void)saveFavorites {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:favorites forKey:@"favorites"];
	[defaults synchronize];
}

- (BOOL)hasFavoriteForTitle:(NSString *)title {
	return [favorites containsObject:[self favoriteForTitle:title]];
}

- (void)createFavoriteForTitle:(NSString *)title {
	@synchronized(self) {
		[favorites addObject:[self favoriteForTitle:title]];
		[self saveFavorites];
	}
}

- (void)moveFavoriteAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
	@synchronized(self) {
		if(fromIndex != toIndex) {
			id obj = [favorites objectAtIndex:fromIndex];
			[obj retain];
			[favorites removeObjectAtIndex:fromIndex];

			if(toIndex >= [favorites count]) {
				[favorites addObject:obj];
			} else {
				[favorites insertObject:obj atIndex:toIndex];
			}

			[obj release];
			[self saveFavorites];
		}
	}
}

- (void)deleteFavoriteAtIndex:(NSUInteger)index {
	@synchronized(self) {
		[favorites removeObjectAtIndex:index];
		[self saveFavorites];
	}
}

- (void)deleteFavoriteForTitle:(NSString *)title {
	@synchronized(self) {
		[favorites removeObject:[self favoriteForTitle:title]];
		[self saveFavorites];
	}
}

@end
