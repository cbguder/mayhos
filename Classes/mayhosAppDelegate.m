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
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *dictionaryPath = [bundle pathForResource:@"defaults" ofType:@"plist"];
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:dictionaryPath];
	[defaults registerDefaults:dictionary];

	tabBarController.selectedIndex = [defaults integerForKey:@"selectedIndex"];

	// Add the tab bar controller's current view as a subview of the window
	[window addSubview:tabBarController.view];
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
	if(orientation == UIDeviceOrientationUnknown) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	} else {
		return toInterfaceOrientation == orientation;
	}
}

@end
