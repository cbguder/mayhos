//
//  EntryController.h
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiTitle.h"

@class MGTemplateEngine;

@interface EntryController : UIViewController <UIWebViewDelegate> {
	EksiTitle *eksiTitle;
	NSUInteger index;

	UIWebView *webView;
	UISegmentedControl *upDownControl;

	MGTemplateEngine *templateEngine;
	NSString *entryTemplate;
	NSURL *baseURL;
}

- (id)initWithEksiTitle:(EksiTitle *)title index:(NSUInteger)index;

@end
