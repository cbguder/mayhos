//
//  FavoritedLeftFrameController.h
//  mayhos
//
//  Created by Can Berk Güder on 23/7/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftFrameController.h"

@interface FavoritedLeftFrameController : LeftFrameController {
	UIBarButtonItem *favoriteItem;
	BOOL favorited;
	
}

@property (nonatomic,retain) UIBarButtonItem *favoriteItem;
@property (nonatomic,assign) BOOL favorited;

@end
