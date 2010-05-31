//
//  LeftFrameController.h
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedController_Pad.h"

@interface LeftFrameController : PagedController_Pad {
	NSArray *links;
	NSURL *URL;
}

@property (nonatomic,retain) NSArray *links;
@property (nonatomic,retain) NSURL *URL;

@end
