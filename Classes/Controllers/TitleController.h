//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePickerView.h"
#import "EksiTitle.h"
#import "EksiEntry.h"

@interface TitleController : UITableViewController <EksiTitleDelegate, PagePickerDelegate> {
	UIBarButtonItem *activityItem;
	UIBarButtonItem *pagesItem;
	UIBarButtonItem *tumuItem;
	PagePickerView *pagePicker;
	EksiTitle *eksiTitle;
}

@property (nonatomic,retain) EksiTitle *eksiTitle;

- (id)initWithEksiTitle:(EksiTitle *)theTitle;

@end
