//
//  EksiParser.m
//  mayhos
//
//  Created by Can Berk Güder on 8/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "EksiParser.h"

@implementation EksiParser

@synthesize delegate, pages, results, URL;

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
	[delegate release];
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
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
}

- (void)getPages:(xmlNodePtr)node {
	while(node) {
		if(node->type == XML_ELEMENT_NODE && xmlStrEqual(node->name, (const xmlChar *)"select")) {
			for(xmlAttrPtr attr = node->properties; attr; attr = attr->next) {
				if(xmlStrEqual(attr->name, (const xmlChar *)"class")) {
					xmlChar *value = xmlNodeListGetString(node->doc, attr->children, YES);
					if(xmlStrstr(value, (const xmlChar *)"pagis") != NULL) {
						pages = xmlChildElementCount(node);
						return;
					}
				}
			}
		}
		
		[self getPages:node->children];
		
		node = node->next;
	}	
}

- (void)parseDocument {
	[self getPages:root];	
}

- (void)connectionFinished {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	xmlFreeDoc(context->myDoc);
	xmlFreeParserCtxt(context);
	xmlCleanupParser();

	NSLog(@"%d Pages.", pages);

	[delegate parserDidFinishParsing:self];
}

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	htmlParseChunk(context, (const char *)[data bytes], [data length], NO);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
														  message:[error localizedDescription]
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];

	[self connectionFinished];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	htmlParseChunk(context, NULL, 0, YES);
	root = xmlDocGetRootElement(context->myDoc);

	[self parseDocument];
	[self connectionFinished];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	self.URL = request.URL;
	return request;
}

@end
