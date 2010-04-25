//
//  FavoritesManager.m
//  mayhos
//
//  Created by Can Berk Güder on 11/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "FavoritesManager.h"
#import "NSURL+Query.h"

static FavoritesManager *SharedManager = nil;

@interface FavoritesManager (Private)
- (NSDictionary *)findFavoriteForURL:(NSURL *)URL;
- (NSDictionary *)favoriteForTitle:(NSString *)title;
- (NSDictionary *)favoriteForURL:(NSURL *)URL withTitle:(NSString *)title;
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

- (NSDictionary *)favoriteForURL:(NSURL *)URL withTitle:(NSString *)title {
	NSURL *realURL = [URL normalizedURL];

	NSMutableDictionary *favorite = [NSMutableDictionary dictionaryWithCapacity:3];
	[favorite setObject:[NSNumber numberWithUnsignedInt:FavoriteTypeSearch] forKey:@"type"];
	[favorite setObject:[realURL absoluteString] forKey:@"URL"];
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

- (NSDictionary *)findFavoriteForURL:(NSURL *)URL {
	NSURL *realURL = [URL normalizedURL];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(URL == %@)", [realURL absoluteString]];
	NSArray *matches = [favorites filteredArrayUsingPredicate:predicate];

	if([matches count]) {
		return [matches objectAtIndex:0];
	} else {
		return nil;
	}
}

- (BOOL)hasFavoriteForURL:(NSURL *)URL {
	NSDictionary *favorite = [self findFavoriteForURL:URL];
	return favorite != nil;
}

- (void)createFavoriteForTitle:(NSString *)title {
	@synchronized(self) {
		[favorites addObject:[self favoriteForTitle:title]];
		[self saveFavorites];
	}
}

- (void)createFavoriteForURL:(NSURL *)URL withTitle:(NSString *)title {
	@synchronized(self) {
		[favorites addObject:[self favoriteForURL:URL withTitle:title]];
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

- (void)deleteFavoriteForURL:(NSURL *)URL {
	@synchronized(self) {
		NSDictionary *favorite = [self findFavoriteForURL:URL];
		if(favorite) {
			[favorites removeObject:favorite];
			[self saveFavorites];
		}
	}
}

@end
