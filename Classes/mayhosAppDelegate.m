//
//  mayhosAppDelegate.m
//  mayhos
//
//  Created by Can Berk Güder on 29/12/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "mayhosAppDelegate.h"

@implementation mayhosAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Add the tab bar controller's current view as a subview of the window
	[window addSubview:tabBarController.view];
}

- (void)dealloc {
	[tabBarController release];
	[window release];
	[super dealloc];
}

@end
