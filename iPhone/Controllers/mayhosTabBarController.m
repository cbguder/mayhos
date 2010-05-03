//
//  mayhosTabBarController.m
//  mayhos
//
//  Created by Can Berk Güder on 6/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "mayhosTabBarController.h"

@implementation mayhosTabBarController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate_Phone *delegate = (mayhosAppDelegate_Phone *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

@end
