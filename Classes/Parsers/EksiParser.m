//
//  EksiParser.m
//  mayhos
//
//  Created by Can Berk Güder on 8/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "EksiParser.h"
#import "NSURL+Query.h"
#import "NSDictionary+URLEncoding.h"

@interface EksiParser ()
@property (nonatomic,retain) NSURLConnection *connection;

- (void)_processNode:(xmlNodePtr)node;
- (void)_processANode:(xmlNodePtr)node;
- (void)_processOptionNode:(xmlNodePtr)node;
- (void)_processSelectNode:(xmlNodePtr)node;
@end

@implementation EksiParser

@synthesize delegate, pages, currentPage, results, URL, baseURL, connection;

- (id)init {
	return [self initWithURL:nil delegate:nil];
}

- (id)initWithURL:(NSURL *)theURL delegate:(id<EksiParserDelegate>)theDelegate {
	if(self = [super init]) {
		[self setURL:theURL];
		[self setDelegate:theDelegate];
		[self setResults:[NSMutableArray array]];
	}

	return self;
}

- (void)dealloc {
	if(self.connection) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[connection cancel];
		[connection release];
	}

	[results release];
	[URL release];

	[super dealloc];
}

- (void)parse {
	context = htmlCreatePushParserCtxt(NULL, NULL, NULL, 0, NULL, XML_CHAR_ENCODING_UTF8);

	NSURLRequest *request =	[NSURLRequest requestWithURL:URL
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval:60];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)parseDocument {
	[self _processNode:root];

	if(pages == 0)
		pages = 1;
}

- (void)cleanupLibxml {
	xmlFreeDoc(context->myDoc);
	xmlFreeParserCtxt(context);
	xmlCleanupParser();
}

#pragma mark Node Processing Methods

- (void)_processNode:(xmlNodePtr)node {
	while(node) {
		if(node->type == XML_ELEMENT_NODE) {
			if(xmlStrEqual(node->name, (const xmlChar *)"select")) {
				[self _processSelectNode:node];
				[self _processNode:node->children];
			} else if(xmlStrEqual(node->name, (const xmlChar *)"option")) {
				[self _processOptionNode:node];
			} else if(xmlStrEqual(node->name, (const xmlChar *)"a")) {
				[self _processANode:node];
			} else {
				[self _processNode:node->children];
			}
		}

		node = node->next;
	}
}

- (void)_processANode:(xmlNodePtr)node {
	BOOL pageLink = NO;
	NSString *pageURL;

	for(xmlAttrPtr attr = node->properties; attr; attr = attr->next) {
		if(xmlStrEqual(attr->name, (const xmlChar *)"title")) {
			xmlChar *value = xmlNodeListGetString(node->doc, attr->children, YES);
			if(xmlStrEqual(value, (const xmlChar *)"önceki sayfa") || xmlStrEqual(value, (const xmlChar *)"sonraki sayfa")) {
				pageLink = YES;
			}
			xmlFree(value);
		} else if(xmlStrEqual(attr->name, (const xmlChar *)"href")) {
			xmlChar *value = xmlNodeListGetString(node->doc, attr->children, YES);
			pageURL = [NSString stringWithUTF8String:(const char *)value];
			xmlFree(value);
		}
	}

	if(pageLink) {
		NSURL *tempURL = [NSURL URLWithString:[kSozlukURL stringByAppendingString:pageURL]];

		NSDictionary *queryDictionary = [tempURL queryDictionary];
		NSMutableDictionary *newQueryDictionary = [NSMutableDictionary dictionary];

		for(NSString *key in [queryDictionary allKeys]) {
			if(![key isEqualToString:@"p"] && ![[queryDictionary valueForKey:key] isEqualToString:@""]) {
				[newQueryDictionary setObject:[queryDictionary valueForKey:key] forKey:key];
			}
		}

		NSString *newString = [kSozlukURL stringByAppendingFormat:@"%@?%@", [[tempURL path] substringFromIndex:1], [newQueryDictionary urlEncodedString]];
		baseURL = [NSURL URLWithString:newString];
	}
}

- (void)_processOptionNode:(xmlNodePtr)node {
	for(xmlAttrPtr attr = node->properties; attr; attr = attr->next) {
		if(xmlStrEqual(attr->name, (const xmlChar *)"selected")) {
			xmlChar *value = xmlNodeListGetString(node->doc, attr->children, YES);

			if(xmlStrEqual(value, (const xmlChar *)"selected")) {
				currentPage = 0;
				for(xmlNodePtr child = node->parent->children; child; child = child->next) {
					currentPage++;
					if(child == node)
						break;
				}
			}

			xmlFree(value);
		}

		return;
	}
}

- (void)_processSelectNode:(xmlNodePtr)node {
	for(xmlAttrPtr attr = node->properties; attr; attr = attr->next) {
		if(xmlStrEqual(attr->name, (const xmlChar *)"class")) {
			xmlChar *value = xmlNodeListGetString(node->doc, attr->children, YES);

			if(xmlStrstr(value, (const xmlChar *)"pagis") != NULL) {
				pages = xmlChildElementCount(node);
			}

			xmlFree(value);
		}

		return;
	}
}

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	htmlParseChunk(context, (const char *)[data bytes], [data length], NO);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.connection = nil;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self cleanupLibxml];

	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
														  message:[error localizedDescription]
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];

	if([delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
		[delegate parser:self didFailWithError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.connection = nil;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	htmlParseChunk(context, NULL, 0, YES);
	root = xmlDocGetRootElement(context->myDoc);
	[self parseDocument];
	[self cleanupLibxml];

	if([delegate respondsToSelector:@selector(parserDidFinishParsing:)]) {
		[delegate parserDidFinishParsing:self];
	}
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	self.URL = request.URL;
	return request;
}

@end
