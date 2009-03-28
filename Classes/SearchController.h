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
	int activeConnections;
}

@property (nonatomic, retain) UISearchBar *mySearchBar;
- (void) decrementActiveConnections;

@end
