//
//  FavoritesManager.h
//  mayhos
//
//  Created by Can Berk Güder on 11/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	FavoriteTypeTitle,
	FavoriteTypeSearch
} FavoriteType;

@interface FavoritesManager : NSObject {
	NSMutableArray *favorites;
}

@property (nonatomic,readonly) NSArray *favorites;

+ (FavoritesManager *)sharedManager;

- (BOOL)hasFavoriteForTitle:(NSString *)title;
- (BOOL)hasFavoriteForURL:(NSURL *)URL;

- (void)createFavoriteForTitle:(NSString *)title;
- (void)createFavoriteForURL:(NSURL *)URL withTitle:(NSString *)title;

- (void)moveFavoriteAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (void)deleteFavoriteAtIndex:(NSUInteger)index;
- (void)deleteFavoriteForTitle:(NSString *)title;
- (void)deleteFavoriteForURL:(NSURL *)URL;

@end
