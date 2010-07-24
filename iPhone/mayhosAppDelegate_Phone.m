//
//  mayhosAppDelegate_Phone.m
//  mayhos
//
//  Created by Can Berk Güder on 29/12/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "mayhosAppDelegate_Phone.h"

@implementation mayhosAppDelegate_Phone

@synthesize window;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[super application:application didFinishLaunchingWithOptions:launchOptions];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	tabBarController.selectedIndex = [defaults integerForKey:@"selectedIndex"];

	// Add the tab bar controller's current view as a subview of the window
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];

	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:tabBarController.selectedIndex forKey:@"selectedIndex"];
}

- (void)dealloc {
	[tabBarController release];
	[window release];
	[super dealloc];
}

- (void)lockOrientation:(UIInterfaceOrientation)toOrientation {
	orientation = toOrientation;
}

- (void)unlockOrientation {
	orientation = UIDeviceOrientationUnknown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (orientation == UIDeviceOrientationUnknown) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	} else {
		return toInterfaceOrientation == orientation;
	}
}

@end
