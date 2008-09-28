//
//  RecentsController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiLinkController.h"
#import "TitleController.h"

@interface RecentsController : EksiLinkController {
	UIBarButtonItem	*refreshItem;
}

-(void)refresh;

@end
