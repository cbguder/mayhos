//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleController : UITableViewController {
	NSMutableData *responseData;
	NSMutableArray *entries;	
	NSURL *myURL;

	UIBarButtonItem *activityItem;
}

- (id)initWithTitle:(NSString *)title;

@end
