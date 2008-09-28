//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleController : UITableViewController {
	NSURLConnection *connection;
	NSMutableData *responseData;
	NSMutableArray *entries;
	NSString *tumu_link;
	NSURL *myURL;

	UIBarButtonItem *activityItem;
	UIBarButtonItem	*tumuItem;
}

- (id)initWithTitle:(NSString *)title URL:(NSURL *)url;

@end
