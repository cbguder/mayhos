//
//  EksiTitle.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 29/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EksiParser.h"
#import "EksiLink.h"

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

@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) NSURL *URL;
@property (nonatomic,retain) NSURL *moreURL;
@property (nonatomic,retain) NSURL *baseURL;

@property (nonatomic,readonly) NSArray *entries;
@property (nonatomic,readonly) BOOL hasMoreToLoad;

@property (nonatomic,readonly) NSUInteger pages;
@property (nonatomic,readonly) NSUInteger currentPage;

@property (nonatomic,assign) id<EksiTitleDelegate> delegate;

+ (EksiTitle *)titleForLink:(EksiLink *)link;

- (BOOL)isEmpty;
- (void)loadEntries;
- (void)loadAllEntries;
- (void)loadPage:(NSUInteger)page;

@end

@protocol EksiTitleDelegate
@optional
- (void)titleDidFinishLoadingEntries:(EksiTitle *)title;
- (void)title:(EksiTitle *)title didFailWithError:(NSError *)error;
@end
