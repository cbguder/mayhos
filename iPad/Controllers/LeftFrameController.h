//
//  LeftFrameController.h
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedTableViewController.h"
#import "EksiParser.h"

@interface LeftFrameController : PagedTableViewController <EksiParserDelegate> {
	NSArray *links;
	NSURL *URL;

	UIBarButtonItem *favoriteItem;
	BOOL favoritable;
	BOOL favorited;
}

@property (nonatomic,retain) NSArray *links;
@property (nonatomic,retain) NSURL *URL;

@property (nonatomic,retain) UIBarButtonItem *favoriteItem;
@property (nonatomic,assign) BOOL favoritable;
@property (nonatomic,assign) BOOL favorited;

@end
