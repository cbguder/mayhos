//
//  RefreshedController.h
//  mayhos
//
//  Created by Can Berk Güder on 25/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiLinkController.h"

@interface RefreshedController : EksiLinkController {
	UIBarButtonItem *refreshItem;
	BOOL refreshItemEnabled;
}

@property (nonatomic,retain) UIBarButtonItem *refreshItem;
@property (nonatomic,assign) BOOL refreshItemEnabled;

- (void)refresh;

@end
