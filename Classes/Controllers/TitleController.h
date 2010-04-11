//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedController.h"
#import "PagePickerView.h"
#import "EksiTitle.h"
#import "EksiEntry.h"

@interface TitleController : PagedController <EksiTitleDelegate> {
	EksiTitle *eksiTitle;

	UIBarButtonItem *favoriteItem;
	UIBarButtonItem *searchItem;
	UIBarButtonItem *tumuItem;

	BOOL favorited;
}

@property (nonatomic,retain) EksiTitle *eksiTitle;

@property (nonatomic,retain) UIBarButtonItem *favoriteItem;
@property (nonatomic,retain) UIBarButtonItem *searchItem;
@property (nonatomic,retain) UIBarButtonItem *tumuItem;

@property (nonatomic,assign) BOOL favorited;

- (id)initWithEksiTitle:(EksiTitle *)theTitle;

@end
