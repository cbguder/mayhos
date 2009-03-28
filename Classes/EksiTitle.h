//
//  EksiTitle.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiEntry.h"

@protocol EksiTitleDelegate;

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
	NSMutableString *tempButtonText;
	BOOL inEntry;
	BOOL inPagis;
	BOOL inButton;
	BOOL inAuthor;
	BOOL inAuthorName;

	int pages;
	int loadedPages;
	
	id delegate;
}

- (id)initWithTitle:(NSString *)theTitle;
- (id)initWithTitle:(NSString *)theTitle URL:(NSURL *)theURL;
- (void)loadEntries;
- (void)loadAllEntries;
- (void)loadOneMorePage;
- (void)loadEntriesFromURL:(NSURL *)theURL;

@property (retain) NSString *title;
@property (retain) NSURL *URL;
@property (retain) NSURL *allURL;
@property (readonly) NSArray *entries;
@property (readonly) BOOL hasMoreToLoad;

@property (assign) id<EksiTitleDelegate> delegate;

@property (readonly) int pages;
@property (readonly) int loadedPages;

@end

@protocol EksiTitleDelegate <NSObject>
- (void)titleDidFinishLoadingEntries:(EksiTitle *)title;
- (void)title:(EksiTitle *)title didFailLoadingEntriesWithError:(NSError *)error;
@end
