//
//  EksiTitle.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import "EksiTitle.h"

@implementation EksiTitle

#pragma mark Initialization Methods

- (id)initWithTitle:(NSString *)theTitle {
	return [self initWithTitle:theTitle URL:nil];
}

- (id)initWithTitle:(NSString *)theTitle URL:(NSURL *)theURL {
	[super init];
	[self setTitle:theTitle];
	[self setURL:theURL];
	
	responseData = [[NSMutableData alloc] init];
	entries = [[NSMutableArray alloc] init];
	hasMoreToLoad = NO;
	
	return self;
}

- (void) dealloc {
	[title release];
	[URL release];
	[allURL release];
	
	[connection release];
	[responseData release];
	[entries release];
	
	[super dealloc];
}

#pragma mark Accessors

@synthesize delegate;
@synthesize title;
@synthesize URL;
@synthesize allURL;
@synthesize entries;
@synthesize hasMoreToLoad;

#pragma mark Other Methods

- (void)loadEntriesWithDelegate:(id)theDelegate {
	[self setDelegate:theDelegate];
	NSURLRequest *request =	[NSURLRequest requestWithURL:URL];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)loadAllEntriesWithDelegate:(id)theDelegate {
	[self setDelegate:theDelegate];
	NSURLRequest *request =	[NSURLRequest requestWithURL:allURL];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	if ([delegate respondsToSelector:@selector(title:didFailLoadingEntriesWithError:)])	{
		[delegate title:self didFailLoadingEntriesWithError:error];
	}	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *entryContent, *author, *date, *tumu_link;
	NSUInteger lastPosition;
	
	static NSString *LI     = @"<li ";
	static NSString *GT     = @">";
	static NSString *DIV    = @"<div class=\"aul\">";
	static NSString *ENDA   = @"</a>";
	static NSString *BUTTON = @"<button ";
	
	NSString  *content = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSScanner *scanner = [NSScanner scannerWithString:content];
	
	static NSString *theXSLTString = @"<?xml version='1.0' encoding='utf-8'?> \
	<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:xhtml='http://www.w3.org/1999/xhtml'> \
	<xsl:output method='text'/> \
	<xsl:template match='xhtml:br'><xsl:text>\n</xsl:text></xsl:template> \
	<xsl:template match='xhtml:a'><xsl:value-of select='.'/></xsl:template> \
	</xsl:stylesheet>";
	
	[entries removeAllObjects];
	
	while ([scanner isAtEnd] == NO) {
		if ([scanner scanUpToString:LI intoString:NULL] &&
		    [scanner scanUpToString:GT intoString:NULL] &&
		    [scanner scanString:GT intoString:NULL] &&
		    [scanner scanUpToString:DIV intoString:&entryContent] &&
		    [scanner scanString:DIV intoString:NULL] &&
		    [scanner scanUpToString:GT intoString:NULL] &&
		    [scanner scanString:GT intoString:NULL] &&
		    [scanner scanUpToString:ENDA intoString:&author] &&
		    [scanner scanString:ENDA intoString:NULL] &&
		    [scanner scanString:@", " intoString:NULL] &&
		    [scanner scanUpToString:@")" intoString:&date])
		{
			lastPosition = [scanner scanLocation];
			
			NSXMLDocument *theDocument = [[[NSXMLDocument alloc] initWithXMLString:entryContent options:NSXMLDocumentTidyHTML error:NULL] autorelease];
			NSData *theData = [theDocument objectByApplyingXSLTString:theXSLTString arguments:NULL error:NULL];
			entryContent = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
			
			NSDate *entryDate;
			NSDate *entryLastEdit;
			
			NSArray *dateParts = [date componentsSeparatedByString:@" ~ "];
			if([dateParts count] == 1) {
				entryDate = [EksiEntry parseDate:[dateParts objectAtIndex:0]];
				entryLastEdit = nil;
			} else if ([dateParts count] > 1) {
				entryDate     = [EksiEntry parseDate:[dateParts objectAtIndex:0]];
				entryLastEdit = [EksiEntry parseDate:[dateParts objectAtIndex:1] withBaseDate:[dateParts objectAtIndex:0]];
			}
			
			EksiEntry *entry = [[EksiEntry alloc] initWithAuthor:author
														 content:entryContent
															date:entryDate
														lastEdit:entryLastEdit];
			[entries addObject:entry];
			[entry release];
		} else {
			[scanner setScanLocation:lastPosition];
			if ([scanner scanUpToString:BUTTON intoString:NULL] &&
			    [scanner scanUpToString:@"'" intoString:NULL] &&
			    [scanner scanString:@"'" intoString:NULL] &&
			    [scanner scanUpToString:@"'" intoString:&tumu_link])
			{
				tumu_link = [tumu_link stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
				[self setAllURL:[NSURL URLWithString:tumu_link relativeToURL:self.URL]];
				hasMoreToLoad = YES;
				break;
			} else {
				hasMoreToLoad = NO;
			}
		}
	}
	
	if ([delegate respondsToSelector:@selector(titleDidFinishLoadingEntries:)]) {
		[delegate titleDidFinishLoadingEntries:self];
	}
}

@end
