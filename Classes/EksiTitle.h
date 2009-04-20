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
	int pages;
	int loadedPages;

	id delegate;
	
	// NSURLConnection Members
	NSMutableData *responseData;
	NSURLConnection *myConnection;

	// NSXMLParser Members
	EksiEntry *tempEntry;
	NSMutableString *tempButtonText;
	NSMutableString *tempContent;
	NSMutableString *tempTitle;
	BOOL inAuthor;
	BOOL inAuthorName;
	BOOL inButton;
	BOOL inEntry;
	BOOL inPagis;
	BOOL inTitle;
}

- (void)loadEntries;
- (void)loadAllEntries;
- (void)loadOneMorePage;
- (void)loadEntriesFromURL:(NSURL *)theURL;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) NSURL *URL;
@property (nonatomic,retain) NSURL *allURL;
@property (nonatomic,readonly) NSArray *entries;
@property (nonatomic,readonly) BOOL hasMoreToLoad;
@property (nonatomic,readonly) int pages;
@property (nonatomic,readonly) int loadedPages;

@property (nonatomic,assign) id<EksiTitleDelegate> delegate;

@property (nonatomic,retain) NSURLConnection *myConnection;

@end

@protocol EksiTitleDelegate <NSObject>
@optional
- (void)titleDidFinishLoadingEntries:(EksiTitle *)title;
- (void)title:(EksiTitle *)title didFailLoadingEntriesWithError:(NSError *)error;
@end
