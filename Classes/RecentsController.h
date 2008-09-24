//
//  RecentsController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleController.h"

@interface RecentsController : UITableViewController {
	NSMutableData *responseData;
	NSMutableArray *stories;	
	NSURL *myURL;
	
	UIBarButtonItem *activityItem;
	UIBarButtonItem	*refreshItem;
}

-(void)refresh;

@end
