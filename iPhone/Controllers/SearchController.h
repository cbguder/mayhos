//
//  SearchController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiLinkController.h"
#import "TitleController.h"
#import "EksiTitle.h"

@interface SearchController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *matches;
	UIBarButtonItem *advancedSearchItem;
}

@property (nonatomic,retain) NSMutableArray *matches;
@property (nonatomic,retain) UIBarButtonItem *advancedSearchItem;

@end
