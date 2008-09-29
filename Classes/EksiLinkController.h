//
//  EksiLinkController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/28/08.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleController.h"
#import "EksiTitle.h"

@interface EksiLinkController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *myTableView;
	UIBarButtonItem *activityItem;	
	NSURLConnection *myConnection;
	NSMutableData *responseData;
	NSMutableArray *stories;	
	BOOL todayMode;
	NSURL *myURL;
}

@property (nonatomic, retain) UITableView *myTableView;

@end
