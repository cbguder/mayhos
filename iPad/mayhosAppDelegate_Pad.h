//
//  mayhosAppDelegate_Pad.h
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeftFrameController.h"
#import "RightFrameController.h"

@interface mayhosAppDelegate_Pad : NSObject <UIApplicationDelegate> {
	UIWindow *window;

	UISplitViewController *splitViewController;

	LeftFrameController *leftFrameController;
	RightFrameController *rightFrameController;
}

@property (nonatomic,retain) IBOutlet UIWindow *window;

@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet LeftFrameController *leftFrameController;
@property (nonatomic,retain) IBOutlet RightFrameController *rightFrameController;

@end
