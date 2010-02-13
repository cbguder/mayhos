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
	UIBarButtonItem *tumuItem;
	EksiTitle *eksiTitle;
}

@property (nonatomic,retain) UIBarButtonItem *tumuItem;
@property (nonatomic,retain) EksiTitle *eksiTitle;

- (id)initWithEksiTitle:(EksiTitle *)theTitle;

@end
