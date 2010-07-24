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

	NSUInteger pages;
	NSUInteger currentPage;

	BOOL favorited;
}

@property (nonatomic,retain) UIBarButtonItem *favoriteItem;
@property (nonatomic,retain) UIBarButtonItem *activityItem;
@property (nonatomic,retain) UIBarButtonItem *pagesItem;

@property (nonatomic,assign) BOOL favorited;

- (void)resetNavigationBar;
- (void)loadPage:(NSUInteger)page;
- (void)finishedLoadingPage;
- (void)favorite;

@end
