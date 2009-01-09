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
	NSMutableArray *entries;
	BOOL hasMoreToLoad;

	NSURLConnection *connection;
	NSMutableData *responseData;
	
	EksiEntry *tempEntry;
	NSMutableString *tempContent;
	BOOL inEntry;
	BOOL inAuthor;
	BOOL inAuthorName;
	
	id delegate;
}

- (id)initWithTitle:(NSString *)theTitle;
- (id)initWithTitle:(NSString *)theTitle URL:(NSURL *)theURL;
- (void) loadEntriesWithDelegate:(id)theDelegate;
- (void) loadAllEntriesWithDelegate:(id)theDelegate;

@property (retain) NSString *title;
@property (retain) NSURL *URL;
@property (retain) NSURL *allURL;
@property (readonly) NSArray *entries;
@property (readonly) BOOL hasMoreToLoad;

@property (assign) id delegate;

@end

@interface NSObject (EksiTitleDelegate)
- (void)titleDidFinishLoadingEntries:(EksiTitle *)title;
- (void)title:(EksiTitle *)title didFailLoadingEntriesWithError:(NSError *)error;
@end
