//
//  EksiTitle.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 29/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiTitle.h"
#import "NSURL+Query.h"
#import "NSDictionary+URLEncoding.h"
#import "RightFrameParser.h"
#import "EksiEntry.h"

@interface EksiTitle ()
@property (nonatomic,retain) RightFrameParser *parser;
- (void)loadEntriesFromURL:(NSURL *)theURL;
@end

@implementation EksiTitle

@synthesize delegate, title, URL, moreURL, baseURL, entries, hasMoreToLoad, pages, currentPage, parser;

+ (id)titleForLink:(EksiLink *)link {
	return [EksiTitle titleWithTitle:link.title URL:link.URL];
}

+ (id)titleWithTitle:(NSString *)theTitle {
	return [[[EksiTitle alloc] initWithTitle:theTitle URL:[API URLForTitle:theTitle]] autorelease];
}

+ (id)titleWithURL:(NSURL *)theURL {
	return [[[EksiTitle alloc] initWithTitle:@"" URL:theURL] autorelease];
}

+ (id)titleWithTitle:(NSString *)theTitle URL:(NSURL *)theURL {
	return [[[EksiTitle alloc] initWithTitle:theTitle URL:theURL] autorelease];
}

#pragma mark Initialization Methods

- (id)init {
	return [self initWithTitle:nil URL:nil];
}

- (id)initWithTitle:(NSString *)theTitle URL:(NSURL *)theURL {
	if ((self = [super init])) {
		self.title = theTitle;
		self.URL = theURL;

		entries = [[NSMutableArray alloc] init];
		currentPage = 1;
		pages = 1;
	}

	return self;
}

- (void) dealloc {
	[parser setDelegate:nil];
	[parser release];
	[title release];
	[URL release];
	[moreURL release];
	[baseURL release];
	[entries release];

	[super dealloc];
}

#pragma mark Accessors

- (BOOL)isEmpty {
	if ([entries count] > 0) {
		EksiEntry *firstEntry = [entries objectAtIndex:0];
		if (firstEntry.author == nil) {
			return YES;
		} else {
			return NO;
		}
	}

	return YES;
}

#pragma mark Other Methods

- (void)loadEntries {
	[self loadEntriesFromURL:URL];
}

- (void)loadAllEntries {
	[self loadEntriesFromURL:moreURL];
}

- (void)loadPage:(NSUInteger)page {
	if (0 < page && page <= pages) {
		hasMoreToLoad = NO;

		if (page == 1) {
			[self loadEntriesFromURL:baseURL];
		} else {
			NSMutableString *allURLString = [[baseURL absoluteString] mutableCopy];
			[allURLString appendFormat:@"&p=%d", page];
			[self loadEntriesFromURL:[NSURL URLWithString:allURLString]];
			[allURLString release];
		}
	}
}

- (void)loadEntriesFromURL:(NSURL *)theURL {
	self.parser = [[RightFrameParser alloc] initWithURL:theURL delegate:self];
	[parser release];
	[parser parse];
}

#pragma mark Parser delegate

- (void)parserDidFinishParsing:(RightFrameParser *)aParser {
	[entries release];
	entries = [aParser.results copy];

	pages = aParser.pages;
	currentPage = aParser.currentPage;
	self.URL = aParser.URL;
	self.moreURL = aParser.moreURL;
	self.baseURL = aParser.baseURL;

	NSMutableCharacterSet *suffix = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
	[suffix addCharactersInString:@"*"];
	self.title = [aParser.title stringByTrimmingCharactersInSet:suffix];
	[suffix release];

	hasMoreToLoad = aParser.hasMoreToLoad;

	self.parser = nil;

	if ([delegate respondsToSelector:@selector(titleDidFinishLoadingEntries:)]) {
		[delegate titleDidFinishLoadingEntries:self];
	}
}

- (void)parser:(EksiParser *)aParser didFailWithError:(NSError *)error {
	self.parser = nil;

	if ([delegate respondsToSelector:@selector(title:didFailWithError:)]) {
		[delegate title:self didFailWithError:error];
	}
}

@end
