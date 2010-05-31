//
//  PagedController_Pad.h
//  mayhos
//
//  Created by Can Berk Güder on 31/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePickerController.h"
#import "EksiParser.h"

@interface PagedController_Pad : UITableViewController <EksiParserDelegate, PagePickerDelegate> {
	NSUInteger pages;
	NSUInteger currentPage;

	UIBarButtonItem *pagesItem;
	UIPopoverController *pagesPopover;
}

- (void)loadPage:(NSUInteger)page;

@end
