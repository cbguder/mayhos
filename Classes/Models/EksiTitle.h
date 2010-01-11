//
//  EksiTitle.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiEntry.h"
#import "EksiParser.h"

@protocol EksiTitleDelegate;

@interface EksiTitle : NSObject <EksiParserDelegate> {
	NSString *title;
	NSURL *URL;
	NSURL *moreURL;
	NSURL *baseURL;

	NSArray *entries;
	BOOL hasMoreToLoad;

	NSUInteger pages;
	NSUInteger currentPage;

	id delegate;
}

- (BOOL)isEmpty;
- (void)loadEntries;
- (void)loadAllEntries;
- (void)loadPage:(NSUInteger)page;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) NSURL *URL;
@property (nonatomic,retain) NSURL *moreURL;
@property (nonatomic,retain) NSURL *baseURL;

@property (nonatomic,readonly) NSArray *entries;
@property (nonatomic,readonly) BOOL hasMoreToLoad;

@property (nonatomic,readonly) NSUInteger pages;
@property (nonatomic,readonly) NSUInteger currentPage;

@property (nonatomic,assign) id<EksiTitleDelegate> delegate;

@end

@protocol EksiTitleDelegate
@optional
- (void)titleDidFinishLoadingEntries:(EksiTitle *)title;
- (void)title:(EksiTitle *)title didFailWithError:(NSError *)error;
@end
