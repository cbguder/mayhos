//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiTitle.h"
#import "EksiEntry.h"

@interface TitleController : UITableViewController {
	NSString *tumu_link;
	EksiTitle *eksiTitle;
	NSURL *myURL;

	UIBarButtonItem *activityItem;
	UIBarButtonItem	*tumuItem;
}

- (id)initWithTitle:(EksiTitle *)theTitle;
- (void)setEksiTitle:(EksiTitle *)theTitle;

@property (retain) EksiTitle *eksiTitle;

@end
