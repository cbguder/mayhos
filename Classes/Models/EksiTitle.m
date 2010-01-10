//
//  EksiTitle.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
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

@synthesize delegate, title, URL, allURL, entries, hasMoreToLoad, pages, currentPage;

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
	[allURL release];
	[entries release];

	[super dealloc];
}

#pragma mark Accessors

- (void)setURL:(NSURL *)theURL {
	[theURL retain];
	[URL release];
	URL = theURL;

	NSString *t = [[theURL queryDictionary] valueForKey:@"t"];
	NSString *query = [[NSDictionary dictionaryWithObject:t forKey:@"t"] urlEncodedString];
	NSString *allURLString = [NSString stringWithFormat:@"http://sozluk.sourtimes.org/show.asp?%@", query];
	[self setAllURL:[NSURL URLWithString:allURLString]];
}

#pragma mark Other Methods

- (void)loadEntries {
	[self loadEntriesFromURL:URL];
}

- (void)loadAllEntries {
	[self loadPage:1];
}

- (void)loadPage:(NSUInteger)page {
	if(0 < page && page <= pages) {
		hasMoreToLoad = NO;
		loadingPage = page;

		if(page == 1) {
			[self loadEntriesFromURL:allURL];
		} else {
			NSMutableString *allURLString = [[allURL absoluteString] mutableCopy];
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

	if(loadingPage != 0) {
		currentPage = loadingPage;
		loadingPage = 0;
	}

	pages = parser.pages;
	self.URL = parser.URL;

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
