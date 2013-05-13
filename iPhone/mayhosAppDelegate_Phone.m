//
//  mayhosAppDelegate_Phone.m
//  mayhos
//
//  Created by Can Berk Güder on 29/12/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "mayhosAppDelegate_Phone.h"

#import "TitleController.h"
#import "NSURL+Query.h"

@implementation mayhosAppDelegate_Phone

@synthesize window;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[super application:application didFinishLaunchingWithOptions:launchOptions];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	tabBarController.selectedIndex = [defaults integerForKey:@"selectedIndex"];

	// Add the tab bar controller's current view as a subview of the window
    window.frame = [[UIScreen mainScreen] bounds];
    window.rootViewController = tabBarController;

	[window makeKeyAndVisible];

	return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"mayhos"]) {

        NSString *rest = [url.absoluteString substringFromIndex:8];

        if ([rest hasPrefix:@"/show.asp"]) {
            tabBarController.selectedIndex = 0;
            UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;

            NSURL *realURL = [API URLForPath:rest];
            NSString *titleText = [[realURL queryDictionary] objectForKey:@"t"];

            EksiTitle *title = [EksiTitle titleWithTitle:titleText URL:realURL];
            TitleController *titleController = [[TitleController alloc] initWithEksiTitle:title];
            [navigationController pushViewController:titleController animated:YES];
            [titleController release];

            return YES;
        }
    }

    return NO;
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
	orientation = (UIDeviceOrientation)toOrientation;
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

- (BOOL)shouldAutorotate {
    return orientation == UIDeviceOrientationUnknown;
}

@end
