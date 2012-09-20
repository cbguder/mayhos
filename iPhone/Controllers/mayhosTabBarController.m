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
	return [UIAppDelegatePhone shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    return [UIAppDelegatePhone shouldAutorotate];
}

@end
