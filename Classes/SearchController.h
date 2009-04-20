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

@interface SearchController : EksiLinkController <EksiTitleDelegate> {
	IBOutlet UISearchBar *mySearchBar;
	BOOL directSearchSuccess;
	int activeConnections;
	NSString *lastSearch;
}

@property (nonatomic,retain) UISearchBar *mySearchBar;
@property (nonatomic,copy) NSString *lastSearch;

- (void) decrementActiveConnections;

@end
