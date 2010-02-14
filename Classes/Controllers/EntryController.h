//
//  EntryController.h
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiTitle.h"

@interface EntryController : UIViewController <UIWebViewDelegate> {
	EksiTitle *eksiTitle;
	NSUInteger index;

	UIWebView *contentView;
	UISegmentedControl *upDownControl;

	NSString *entryTemplate;
	NSURL *baseURL;
}

- (id)initWithEksiTitle:(EksiTitle *)title index:(NSUInteger)index;

@end
