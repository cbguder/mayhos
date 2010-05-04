//
//  mayhosAppDelegate_Pad.h
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"
#import "RightFrameController.h"

@interface mayhosAppDelegate_Pad : NSObject <UIApplicationDelegate> {
	UIWindow *window;

	UISplitViewController *splitViewController;

	RootViewController *leftFrameController;
	RightFrameController *rightFrameController;
}

@property (nonatomic,retain) IBOutlet UIWindow *window;

@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet RootViewController *leftFrameController;
@property (nonatomic,retain) IBOutlet RightFrameController *rightFrameController;

@end
