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

	UIToolbar *toolbar;
	UIBarButtonItem *backItem;
	UIBarButtonItem *forwardItem;
	UIBarButtonItem *reloadItem;
	UIBarButtonItem *actionItem;
	UIBarButtonItem *activityItem;
}

@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) NSURL *currentURL;

@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *backItem;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *forwardItem;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *reloadItem;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *actionItem;
@property (nonatomic,retain) UIBarButtonItem *activityItem;

- (id)initWithURL:(NSURL *)URL;
- (IBAction)showActionSheet:(id)sender;

@end
