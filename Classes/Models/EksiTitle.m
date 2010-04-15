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

@interface EksiTitle (Private)
- (void)loadEntriesFromURL:(NSURL *)theURL;
@end

@implementation EksiTitle

@synthesize delegate, title, URL, moreURL, baseURL, entries, hasMoreToLoad, pages, currentPage;

+ (EksiTitle *)titleForLink:(EksiLink *)link {
	EksiTitle *title = [[[EksiTitle alloc] init] autorelease];
	title.title = link.title;
	title.URL = link.URL;
	return title;
}

#pragma mark Initialization Methods

- (id)init {
	if(self = [super init]) {
		entries = [[NSMutableArray alloc] init];
		currentPage = 1;
		pages = 1;
	}

	return self;
}

- (void) dealloc {
	[title release];
	[URL release];
	[moreURL release];
	[baseURL release];
	[entries release];

	[super dealloc];
}

#pragma mark Accessors

- (BOOL)isEmpty {
	if([entries count] > 0) {
		EksiEntry *firstEntry = [entries objectAtIndex:0];
		if(firstEntry.author == nil) {
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
	if(0 < page && page <= pages) {
		hasMoreToLoad = NO;

		if(page == 1) {
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
	RightFrameParser *parser = [[RightFrameParser alloc] initWithURL:theURL delegate:self];
	[parser parse];
}

#pragma mark EksiParserDelegate Methods

- (void)parserDidFinishParsing:(RightFrameParser *)parser {
	[entries release];
	entries = [parser.results copy];

	pages = parser.pages;
	currentPage = parser.currentPage;
	self.URL = parser.URL;
	self.moreURL = parser.moreURL;
	self.baseURL = parser.baseURL;

	NSMutableCharacterSet *suffix = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
	[suffix addCharactersInString:@"*"];
	self.title = [parser.title stringByTrimmingCharactersInSet:suffix];
	[suffix release];

	hasMoreToLoad = parser.hasMoreToLoad;

	[parser release];

	if([delegate respondsToSelector:@selector(titleDidFinishLoadingEntries:)]) {
		[delegate titleDidFinishLoadingEntries:self];
	}
}

- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error {
	[parser release];

	if([delegate respondsToSelector:@selector(title:didFailWithError:)]) {
		[delegate title:self didFailWithError:error];
	}
}

@end
