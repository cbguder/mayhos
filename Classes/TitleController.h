//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiTitle.h"
#import "EksiEntry.h"

@interface TitleController : UITableViewController <EksiTitleDelegate> {
	UIBarButtonItem *activityItem;
	EksiTitle *eksiTitle;
}

- (id)initWithTitle:(EksiTitle *)theTitle;
- (void)setEksiTitle:(EksiTitle *)theTitle;

@property (retain) EksiTitle *eksiTitle;

@end
