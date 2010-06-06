//
//  mayhosAppDelegate_Phone.h
//  mayhos
//
//  Created by Can Berk Güder on 29/12/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIAppDelegatePhone ((mayhosAppDelegate_Phone *)[UIApplication sharedApplication].delegate)

@interface mayhosAppDelegate_Phone : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	UIWindow *window;
	UITabBarController *tabBarController;

	UIDeviceOrientation orientation;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (void)lockOrientation:(UIInterfaceOrientation)orientation;
- (void)unlockOrientation;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
