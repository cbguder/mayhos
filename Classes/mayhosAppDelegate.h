//
//  mayhosAppDelegate.h
//  mayhos
//
//  Created by Can Berk Güder on 29/12/2009.
//  Copyright Can Berk Güder 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mayhosAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
