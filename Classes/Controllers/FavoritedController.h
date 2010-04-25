//
//  FavoritedController.h
//  mayhos
//
//  Created by Can Berk Güder on 21/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedController.h"

@interface FavoritedController : PagedController {
	UIBarButtonItem *favoriteItem;
	BOOL favoriteItemEnabled;
	BOOL favorited;
}

@property (nonatomic,retain) UIBarButtonItem *favoriteItem;
@property (nonatomic,assign) BOOL favoriteItemEnabled;
@property (nonatomic,assign) BOOL favorited;

- (void)favorite;

@end
