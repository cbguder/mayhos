//
//  mayhosAppDelegate_Pad.h
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mayhosAppDelegate.h"
#import "RootViewController.h"
#import "RightFrameController.h"

#define UIAppDelegatePad ((mayhosAppDelegate_Pad *)[UIApplication sharedApplication].delegate)

@interface mayhosAppDelegate_Pad : mayhosAppDelegate {
	UIWindow *window;

	UISplitViewController *splitViewController;
	RightFrameController *rightFrameController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RightFrameController *rightFrameController;

@end
