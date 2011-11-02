//
//  EksiTitle.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 29/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RightFrameParser.h"
#import "EksiLink.h"

@protocol EksiTitleDelegate;

@interface EksiTitle : NSObject <EksiParserDelegate> {
	RightFrameParser *parser;

	NSString *title;
	NSURL *URL;
	NSURL *moreURL;
	NSURL *baseURL;

	NSArray *entries;
	BOOL hasMoreToLoad;

	NSUInteger pages;
	NSUInteger currentPage;

	NSString *message;

	id delegate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain) NSURL *moreURL;
@property (nonatomic, retain) NSURL *baseURL;

@property (nonatomic, readonly) NSArray *entries;
@property (nonatomic, readonly) BOOL hasMoreToLoad;

@property (nonatomic, readonly) NSUInteger pages;
@property (nonatomic, readonly) NSUInteger currentPage;

@property (nonatomic, readonly) NSString *message;

@property (nonatomic, assign) id<EksiTitleDelegate> delegate;

+ (id)titleForLink:(EksiLink *)link;
+ (id)titleWithTitle:(NSString *)title;
+ (id)titleWithURL:(NSURL *)URL;
+ (id)titleWithTitle:(NSString *)title URL:(NSURL *)URL;

- (id)initWithTitle:(NSString *)title URL:(NSURL *)URL;

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
