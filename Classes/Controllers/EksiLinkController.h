//
//  EksiLinkController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 28/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libxml/HTMLparser.h>
#import "PagedController.h"
#import "TitleController.h"
#import "EksiParser.h"

@interface EksiLinkController : PagedController <EksiParserDelegate> {
	UIBarButtonItem *refreshItem;
	NSMutableArray *titles;
	BOOL refreshEnabled;

	NSURL *URL;
}

@property (nonatomic,retain) UIBarButtonItem *refreshItem;
@property (nonatomic,retain) NSMutableArray *titles;
@property (nonatomic,assign) BOOL refreshEnabled;

@property (nonatomic,retain) NSURL *URL;

- (void)loadURL;
- (void)refresh;

@end
