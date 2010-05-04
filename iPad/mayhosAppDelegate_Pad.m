//
//  mayhosAppDelegate_Pad.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "mayhosAppDelegate_Pad.h"

@implementation mayhosAppDelegate_Pad

@synthesize window, splitViewController, leftFrameController, rightFrameController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[window addSubview:splitViewController.view];
	[window makeKeyAndVisible];

	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[splitViewController release];
	[window release];
	[super dealloc];
}

@end
