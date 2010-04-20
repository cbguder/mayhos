//
//  RandomDateController.h
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiLinkController.h"

@interface RandomDateController : EksiLinkController {
	UIBarButtonItem *shuffleItem;
}

@property (nonatomic,retain) UIBarButtonItem *shuffleItem;

@end
