//
//  EksiTitle.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiEntry.h"

@interface EksiTitle : NSObject {
	NSString *title;
	NSURL *URL;
	NSURL *allURL;

	NSURLConnection *connection;
	NSMutableData *responseData;
	NSMutableArray *entries;
	
	id delegate;
}

- (id)initWithTitle:(NSString *)theTitle;
- (id)initWithTitle:(NSString *)theTitle URL:(NSURL *)theURL;
- (void) loadEntriesWithDelegate:(id)theDelegate;
- (void) loadAllEntriesWithDelegate:(id)theDelegate;
- (NSArray *)entries;

@property (retain) NSString *title;
@property (retain) NSURL *allURL;
@property (retain) NSURL *URL;
@property (assign) id delegate;

@end

@interface NSObject (EksiTitleDelegate)
- (void)titleDidFinishLoadingEntries:(EksiTitle *)title;
@end

