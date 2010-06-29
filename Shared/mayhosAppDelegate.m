//
//  mayhosAppDelegate.m
//  mayhos
//
//  Created by Can Berk Güder on 14/6/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "mayhosAppDelegate.h"

@implementation mayhosAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *dictionaryPath = [bundle pathForResource:@"defaults" ofType:@"plist"];
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:dictionaryPath];
	[defaults registerDefaults:dictionary];

	return YES;
}

@end
