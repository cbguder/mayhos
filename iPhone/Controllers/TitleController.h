//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 24/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritedController.h"
#import "PagePickerView.h"
#import "EksiTitle.h"
#import "EksiEntry.h"
#import "TitleView.h"

@interface TitleController : FavoritedController <EksiTitleDelegate, UIAlertViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
	UIBarButtonItem *tumuItem;
	EksiTitle *eksiTitle;
	TitleView *titleView;

	BOOL searchMode;
	BOOL noToolbar;
}

@property (nonatomic, retain) UIBarButtonItem *tumuItem;
@property (nonatomic, retain) EksiTitle *eksiTitle;
@property (nonatomic, retain) TitleView *titleView;

@property (nonatomic, assign) BOOL searchMode;
@property (nonatomic, assign) BOOL noToolbar;

- (id)initWithEksiTitle:(EksiTitle *)theTitle;

@end
