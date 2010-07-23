//
//  mayhosAppDelegate.m
//  mayhos
//
//  Created by Can Berk Güder on 14/6/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "mayhosAppDelegate.h"
#import "NSURL+Query.h"

@implementation mayhosAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:dictionaryPath];
	[defaults registerDefaults:dictionary];

	[self upgradeUserDefaults];

	return YES;
}

- (void)upgradeUserDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *currentVersion = [defaults objectForKey:@"version"];
	static NSString *lastVersion = @"2.2";

	if(currentVersion == nil) {
		NSArray *oldFavorites = [defaults objectForKey:@"favorites"];
		NSMutableArray *newFavorites = [[NSMutableArray alloc] initWithCapacity:[oldFavorites count]];
		NSNumber *searchType = [NSNumber numberWithInt:1];

		for(NSDictionary *favorite in oldFavorites) {
			if([[favorite objectForKey:@"type"] isEqualToNumber:searchType]) {
				NSURL *newURL = [[NSURL URLWithString:[favorite objectForKey:@"URL"]] normalizedURL];
				NSString *newURLString = [NSString stringWithFormat:@"%@?%@", [newURL path], [newURL query]];

				NSMutableDictionary *newFavorite = [favorite mutableCopy];
				[newFavorite setObject:newURLString forKey:@"URL"];
				[newFavorites addObject:newFavorite];
				[newFavorite release];
			} else {
				[newFavorites addObject:favorite];
			}
		}

		[defaults setObject:newFavorites forKey:@"favorites"];
		[defaults setObject:lastVersion forKey:@"version"];
		[defaults synchronize];
	}
}

@end
