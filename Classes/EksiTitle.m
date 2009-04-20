//
//  EksiTitle.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiTitle.h"

@implementation EksiTitle

@synthesize delegate, title, URL, allURL, entries, hasMoreToLoad, pages, loadedPages, myConnection;

#pragma mark Initialization Methods

- (id)init {
	if(self = [super init]) {
        entries = [[NSMutableArray alloc] init];
	}

	return self;
}

- (void)setURL:(NSURL *)theURL {
	[theURL retain];
	[URL release];
	URL = theURL;
	
	NSString *URLString = [theURL absoluteString];

	if([URLString hasSuffix:@"&a=td"]) {
		[self setAllURL:[NSURL URLWithString:[URLString substringToIndex:[URLString length] - 5]]];
	} else {
		[self setAllURL:theURL];
	}
}

- (void) dealloc {
	[myConnection release];
	[title release];
	[URL release];
	[allURL release];
	[entries release];
	
	[super dealloc];
}

#pragma mark Other Methods

- (void)loadEntries {
	[self loadEntriesFromURL:URL];
}

- (void)loadAllEntries {
	[entries removeAllObjects];

	pages = 0;
	loadedPages = 0;
	hasMoreToLoad = NO;

	[self loadEntriesFromURL:allURL];
}

- (void)loadOneMorePage {
	if(loadedPages < pages) {
		NSMutableString *pageURLString = [[allURL absoluteString] mutableCopy];
		[pageURLString appendFormat:@"&p=%d", loadedPages + 1];
		[self loadEntriesFromURL:[NSURL URLWithString:pageURLString]];
		[pageURLString release];
	}
}

- (void)loadEntriesFromURL:(NSURL *)theURL {
	if(myConnection != nil) {
        [myConnection cancel];
        self.myConnection = nil;
    }

	NSURLRequest *request =	[NSURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	self.myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSXMLParserDelegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if([elementName isEqualToString:@"li"])
	{
		tempEntry = [[EksiEntry alloc] init];
		tempContent = [[NSMutableString alloc] init];
		inEntry = YES;
	}
	else if([elementName isEqualToString:@"select"])
	{
		NSString *class = [attributeDict objectForKey:@"class"];
		if([class isEqualToString:@"pagis"])
		{
			inPagis = YES;
			pages = 0;
		}
	}
	else if(inPagis && [elementName isEqualToString:@"option"])
	{
		pages++;
	}
	else if(inEntry)
	{
		if([elementName isEqualToString:@"br"])
		{
			[tempContent appendString:@"\n"];
		}
		else if(inAuthor && [elementName isEqualToString:@"a"])
		{
			inAuthorName = YES;
		}
		else if([elementName isEqualToString:@"div"])
		{
			NSString *class = [attributeDict objectForKey:@"class"];

			if(class && [class isEqualToString:@"aul"])
			{
				inAuthor = YES;
			}
		}
	}
	else if([elementName isEqualToString:@"button"])
	{
		tempButtonText = [[NSMutableString alloc] init];
		inButton = YES;
	}
	else if([elementName isEqualToString:@"h1"])
	{
		tempTitle = [[NSMutableString alloc] init];
		inTitle = YES;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(inEntry)
	{
		if(inAuthor)
		{
			if(inAuthorName)
			{
				tempEntry.author = string;
			}
			else if([string characterAtIndex:0] == ',')
			{
				NSString *date = [string substringWithRange:NSMakeRange(2, [string length] - 3)];
				NSArray *dateParts = [date componentsSeparatedByString:@" ~ "];
				
				if([dateParts count] == 1)
				{
					tempEntry.date     = [EksiEntry parseDate:[dateParts objectAtIndex:0]];
					tempEntry.lastEdit = nil;
				}
				else if ([dateParts count] > 1)
				{
					tempEntry.date     = [EksiEntry parseDate:[dateParts objectAtIndex:0]];
					tempEntry.lastEdit = [EksiEntry parseDate:[dateParts objectAtIndex:1] withBaseDate:[dateParts objectAtIndex:0]];
				}				
			}
		}
		else
		{
			[tempContent appendString:string];
		}
	}
	else if(inButton)
	{
		[tempButtonText appendString:string];
	}
	else if(inTitle)
	{
		[tempTitle appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(inEntry) {
		if(inAuthor && [elementName isEqualToString:@"div"])
		{
			inAuthor = NO;
		}
		else if(inAuthorName && [elementName isEqualToString:@"a"])
		{
			inAuthorName = NO;
		}
		else if([elementName isEqualToString:@"li"])
		{
			tempEntry.content = [tempContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[tempContent release];
			
			[entries addObject:tempEntry];
			[tempEntry release];
			
			inEntry = NO;
		}
		else if(inPagis && [elementName isEqualToString:@"select"])
		{
			inPagis = NO;
		}
	}
	else if(inButton && [elementName isEqualToString:@"button"])
	{
		inButton = NO;
		hasMoreToLoad = [tempButtonText isEqualToString:@"tümünü göster"];
		[tempButtonText release];
	}
	else if(inTitle && [elementName isEqualToString:@"h1"])
	{
		inTitle = NO;

		NSMutableCharacterSet *suffix = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
		[suffix addCharactersInString:@"*"];
		self.title = [tempTitle stringByTrimmingCharactersInSet:suffix];
		[tempTitle release];
		[suffix release];
	}
}

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	[responseData release];
	self.myConnection = nil;

	if(delegate != nil && [delegate respondsToSelector:@selector(didFailLoadingEntriesWithError:)]) {
		[delegate title:self didFailLoadingEntriesWithError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
	[parser setDelegate:self];
	[parser parse];

	[responseData release];
	self.myConnection = nil;
	[parser release];

	loadedPages++;

	// Sanity check
	if(loadedPages > pages) {
		pages = loadedPages;
	}

	if(delegate != nil && [delegate respondsToSelector:@selector(titleDidFinishLoadingEntries:)]) {
		[delegate titleDidFinishLoadingEntries:self];
	}
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	self.URL = request.URL;
	return request;
}

@end
