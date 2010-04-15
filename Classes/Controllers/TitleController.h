//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 24/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedController.h"
#import "PagePickerView.h"
#import "EksiTitle.h"
#import "EksiEntry.h"
#import "TitleView.h"

@interface TitleController : PagedController <EksiTitleDelegate> {
	EksiTitle *eksiTitle;

	TitleView *titleView;

	UIBarButtonItem *favoriteItem;
	UIBarButtonItem *searchItem;
	UIBarButtonItem *tumuItem;

	BOOL searchMode;
	BOOL favorited;
}

@property (nonatomic,retain) EksiTitle *eksiTitle;

@property (nonatomic,retain) TitleView *titleView;

@property (nonatomic,retain) UIBarButtonItem *favoriteItem;
@property (nonatomic,retain) UIBarButtonItem *searchItem;
@property (nonatomic,retain) UIBarButtonItem *tumuItem;

@property (nonatomic,assign) BOOL searchMode;
@property (nonatomic,assign) BOOL favorited;

- (id)initWithEksiTitle:(EksiTitle *)theTitle;

@end
