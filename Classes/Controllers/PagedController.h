//
//  PagedController.h
//  mayhos
//
//  Created by Can Berk Güder on 11/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePickerView.h"

@interface PagedController : UITableViewController <PagePickerDelegate> {
	UIBarButtonItem *activityItem;
	UIBarButtonItem *pagesItem;

	NSUInteger pages;
	NSUInteger currentPage;
}

@property (nonatomic,retain) UIBarButtonItem *activityItem;
@property (nonatomic,retain) UIBarButtonItem *pagesItem;

- (void)pagesClicked:(id)sender;
- (void)loadPage:(NSUInteger)page;
- (void)finishedLoadingPage;
- (void)resetNavigationBar;

@end
