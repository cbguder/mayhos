//
//  RightFrameController.h
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiTitle.h"

@interface RightFrameController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIWebViewDelegate, EksiTitleDelegate> {
    UIPopoverController *popoverController;
	UIWebView *webView;

	NSString *HTMLTemplate;
	NSURL *baseURL;

	EksiTitle *eksiTitle;
}

@property (nonatomic,retain) EksiTitle *eksiTitle;

@end
