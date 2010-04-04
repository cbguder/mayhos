//
//  SearchController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiLinkController.h"
#import "TitleController.h"
#import "EksiTitle.h"

@interface SearchController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableSet *history;
	NSMutableArray *matches;
	NSString *searchTerm;

	UIBarButtonItem *advancedSearchItem;
}

@property (nonatomic,retain) NSMutableSet *history;
@property (nonatomic,retain) NSMutableArray *matches;
@property (nonatomic,copy) NSString *searchTerm;

@property (nonatomic,retain) UIBarButtonItem *advancedSearchItem;

@end
