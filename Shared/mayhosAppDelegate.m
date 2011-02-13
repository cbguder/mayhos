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

	NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
	NSString *defaultsVersion = [defaults objectForKey:@"version"];

	if (defaultsVersion != nil && [defaultsVersion compare:bundleVersion] != NSOrderedAscending) {
		return;
	}

	NSArray *prefixes = [NSArray arrayWithObjects:@"http://www.eksisozluk.com", @"http://sozluk.sourtimes.org", @"(null)://(null)", nil];

	NSArray *oldFavorites = [defaults objectForKey:@"favorites"];
	NSMutableArray *newFavorites = [[NSMutableArray alloc] initWithCapacity:[oldFavorites count]];
	NSNumber *searchType = [NSNumber numberWithInt:1];

	for (NSDictionary *favorite in oldFavorites) {
		if ([[favorite objectForKey:@"type"] isEqualToNumber:searchType]) {
			NSString *oldURL = [favorite objectForKey:@"URL"];
			NSString *newURL = [NSString stringWithString:oldURL];

			for (NSString *prefix in prefixes) {
				if ([oldURL hasPrefix:prefix]) {
					newURL = [oldURL substringFromIndex:[prefix length]];
					break;
				}
			}

			NSMutableDictionary *newFavorite = [favorite mutableCopy];
			[newFavorite setObject:newURL forKey:@"URL"];
			[newFavorites addObject:newFavorite];
			[newFavorite release];
		} else {
			[newFavorites addObject:favorite];
		}
	}

	[defaults setObject:newFavorites forKey:@"favorites"];
	[defaults setObject:bundleVersion forKey:@"version"];
	[defaults synchronize];
}

@end
