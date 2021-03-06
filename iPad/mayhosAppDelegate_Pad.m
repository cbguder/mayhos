//
//  mayhosAppDelegate_Pad.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "mayhosAppDelegate_Pad.h"

@implementation mayhosAppDelegate_Pad

@synthesize window;
@synthesize splitViewController;
@synthesize rightFrameController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[super application:application didFinishLaunchingWithOptions:launchOptions];

	[window addSubview:splitViewController.view];
	[window makeKeyAndVisible];

	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[splitViewController release];
	[window release];
	[super dealloc];
}

@end
