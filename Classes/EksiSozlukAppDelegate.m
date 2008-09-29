//
//  EksiSozlukAppDelegate.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright Chocolate IT Solutions 2008. All rights reserved.
//

#import "EksiSozlukAppDelegate.h"

@implementation EksiSozlukAppDelegate

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
