//
//  WebController.h
//  mayhos
//
//  Created by Can Berk Güder on 10/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	UIWebView *webView;
	NSURL *currentURL;

	UIBarButtonItem *backItem;
	UIBarButtonItem *forwardItem;
	UIBarButtonItem *reloadItem;
	UIBarButtonItem *stopItem;
	UIBarButtonItem *actionItem;
	UIBarButtonItem *activityItem;
}

@property (nonatomic, retain) NSURL *currentURL;

@property (nonatomic, retain) UIBarButtonItem *backItem;
@property (nonatomic, retain) UIBarButtonItem *forwardItem;
@property (nonatomic, retain) UIBarButtonItem *reloadItem;
@property (nonatomic, retain) UIBarButtonItem *stopItem;
@property (nonatomic, retain) UIBarButtonItem *actionItem;
@property (nonatomic, retain) UIBarButtonItem *activityItem;

- (id)initWithURL:(NSURL *)URL;

@end
