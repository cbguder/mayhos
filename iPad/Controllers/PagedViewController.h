//
//  PagedViewController.h
//  mayhos
//
//  Created by Can Berk Güder on 31/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePickerController.h"
#import "EksiParser.h"

@interface PagedViewController : UIViewController <PagePickerControllerDelegate> {
	NSUInteger pages;
	NSUInteger currentPage;

	UIBarButtonItem *pagesItem;
	UIPopoverController *pagesPopover;
}

@property (nonatomic, assign) NSUInteger pages;
@property (nonatomic, assign) NSUInteger currentPage;

- (void)loadPage:(NSUInteger)page;

@end
