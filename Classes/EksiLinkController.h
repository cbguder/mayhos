//
//  EksiLinkController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/28/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleController.h"
#import "EksiTitle.h"

@interface EksiLinkController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *myTableView;
	UIBarButtonItem *activityItem;

	NSURLConnection *myConnection;
	NSMutableData *responseData;
	NSMutableArray *stories;	
	NSURL *myURL;

	BOOL inLink;
	EksiTitle *tempTitle;
	NSMutableString *tempString;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;

- (void)loadURL;

@end
