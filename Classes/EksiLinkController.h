//
//  EksiLinkController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/28/08.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleController.h"

@interface EksiLinkController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *myTableView;
	NSURLConnection *myConnection;
	NSMutableData *responseData;
	NSMutableArray *stories;	
	NSURL *myURL;
	
	UIBarButtonItem *activityItem;	
}

@property (nonatomic, retain) UITableView *myTableView;

@end
