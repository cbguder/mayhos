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

	NSMutableData *responseData;
	NSURLConnection *myConnection;
	
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

	int pages;
	int loadedPages;

	id delegate;
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
@property (nonatomic,retain) NSURLConnection *myConnection;

@property (nonatomic,assign) id<EksiTitleDelegate> delegate;

@property (nonatomic,readonly) int pages;
@property (nonatomic,readonly) int loadedPages;

@end

@protocol EksiTitleDelegate <NSObject>
@optional
- (void)titleDidFinishLoadingEntries:(EksiTitle *)title;
- (void)title:(EksiTitle *)title didFailLoadingEntriesWithError:(NSError *)error;
@end
