//
//  RecentsController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentsController : UITableViewController {
	NSXMLParser *parser;
	NSMutableArray *stories;	
	NSMutableDictionary *item;
	NSString *currentElement, *currentLink;
	NSMutableString *currentTitle;
	NSURL *myURL;
	
	UIBarButtonItem *activityItem;
	UIBarButtonItem	*refreshItem;
}

-(void)parseXMLFileAtURL:(NSURL *)URL;

@end
