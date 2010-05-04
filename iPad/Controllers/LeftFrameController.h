//
//  LeftFrameController.h
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightFrameController.h"

@interface LeftFrameController : UITableViewController {
	RightFrameController *rightFrameController;
}

@property (nonatomic,retain) IBOutlet RightFrameController *rightFrameController;

@end
