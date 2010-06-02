//
//  ModalWebController.h
//  mayhos
//
//  Created by Can Berk Güder on 5/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ReloadStopModeNone,
	ReloadStopModeReload,
	ReloadStopModeStop
} ReloadStopMode;

@interface ModalWebController : UIViewController <UIWebViewDelegate> {
	NSURL *URL;

	UIToolbar *toolbar;
	UIBarButtonItem *backItem;
	UIBarButtonItem *forwardItem;
	UITextField *addressBar;

	UIWebView *webView;

	UIButton *reloadStopButton;
	ReloadStopMode reloadStopMode;
}

@property (nonatomic,retain) NSURL *URL;

@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *backItem;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *forwardItem;
@property (nonatomic,retain) IBOutlet UITextField *addressBar;

@property (nonatomic,retain) IBOutlet UIWebView *webView;

@property (nonatomic,retain) UIButton *reloadStopButton;
@property (nonatomic,assign) ReloadStopMode reloadStopMode;

- (id)initWithURL:(NSURL *)URL;
- (IBAction)close;

@end
