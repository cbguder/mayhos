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

@interface SearchController : EksiLinkController <EksiTitleDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
	BOOL directSearchSuccess;
	EksiTitle *directTitle;
	int activeConnections;

	NSString *savedSearchTerm;
	NSInteger savedScopeButtonIndex;
	BOOL searchWasActive;
}

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (void) decrementActiveConnections;

@end
