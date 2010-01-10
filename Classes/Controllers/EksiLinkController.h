//
//  EksiLinkController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/28/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libxml/HTMLparser.h>
#import "TitleController.h"
#import "EksiParser.h"

@interface EksiLinkController : UITableViewController <EksiParserDelegate> {
	UIBarButtonItem *activityItem;
	NSMutableArray *titles;
	NSURL *URL;
}

@property (nonatomic,retain) NSMutableArray *titles;
@property (nonatomic,retain) NSURL *URL;

- (void)loadURL;

@end
