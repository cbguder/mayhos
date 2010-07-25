//
//  RecentsController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiLinkController.h"

@interface RecentsController : EksiLinkController {
	UIBarButtonItem *refreshItem;
}

@property (nonatomic, retain) UIBarButtonItem *refreshItem;

- (void)refresh;

@end
