//
//  FavoritedController.h
//  mayhos
//
//  Created by Can Berk Güder on 21/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePickerView.h"

@interface FavoritedController : UITableViewController <PagePickerDelegate> {
	UIBarButtonItem *favoriteItem;
	UIBarButtonItem *activityItem;
	UIBarButtonItem *pagesItem;

	NSUInteger numberOfPages;
	NSUInteger currentPage;

	BOOL favorited;
}

@property (nonatomic, retain) UIBarButtonItem *favoriteItem;
@property (nonatomic, retain) UIBarButtonItem *activityItem;
@property (nonatomic, retain) UIBarButtonItem *pagesItem;

@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, assign, getter=isFavorited) BOOL favorited;

- (void)loadPage:(NSUInteger)page;
- (void)favorite;

@end
