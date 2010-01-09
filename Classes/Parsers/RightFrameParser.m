//
//  RightFrameParser.m
//  mayhos
//
//  Created by Can Berk Güder on 8/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RightFrameParser.h"
#import "EksiEntry.h"

@interface RightFrameParser (Private)
- (void)processNode:(xmlNodePtr)node;
- (void)processButtonNode:(xmlNodePtr)node;
- (void)processEntryNode:(xmlNodePtr)node;
- (void)processLiNode:(xmlNodePtr)node;

- (void)extractTextFromNode:(xmlNodePtr)node intoBuffer:(NSMutableString *)buffer;
@end

@implementation RightFrameParser

@synthesize title;

- (id)initWithURL:(NSURL *)theURL delegate:(id<EksiParserDelegate>)theDelegate {
	if(self = [super initWithURL:theURL delegate:theDelegate]) {
		title = [[NSMutableString alloc] init];
		hasMoreToLoad = NO;
	}
	
	return self;
}

- (void)dealloc {
	[title release];

	[super dealloc];
}

- (void)parseDocument {
	[super parseDocument];
	[self processNode:root];
}

- (void)extractTextFromNode:(xmlNodePtr)node intoBuffer:(NSMutableString *)buffer {
	if(node->type == XML_TEXT_NODE) {
		[tempAuthor appendString:[NSString stringWithUTF8String:(const char *)node->content]];
	} else {
		xmlNodePtr child = NULL;
		for(child = node->children; child; child = child->next) {
			[self extractTextFromNode:child intoBuffer:buffer];
		}
	}
}

#pragma mark Node Processing Methods

- (void)processNode:(xmlNodePtr)node {
	while(node) {
		if(node->type == XML_ELEMENT_NODE) {
			if(xmlStrEqual(node->name, (const xmlChar *)"li")) {
				[self processLiNode:node];
			} else if(xmlStrEqual(node->name, (const xmlChar *)"h1")) {
				[self extractTextFromNode:node intoBuffer:title];
			} else if(xmlStrEqual(node->name, (const xmlChar *)"button")) {
				[self processButtonNode:node];
			} else {
				[self processNode:node->children];
			}
		}
		
		node = node->next;
	}
}

- (void)processButtonNode:(xmlNodePtr)node {
	xmlChar *value = xmlNodeListGetString(node->doc, node->children, 0);
	if(xmlStrEqual(value, (const xmlChar *)"tümünü göster")) {
		hasMoreToLoad = YES;
	}
	xmlFree(value);
}

- (void)processEntryNode:(xmlNodePtr)node {
	if(node->type == XML_TEXT_NODE) {
		[tempEntry appendString:[NSString stringWithUTF8String:(const char *)node->content]];
		return;
	}
	
	if(node->type != XML_ELEMENT_NODE) {
		return;
	}

	if(xmlStrEqual(node->name, (const xmlChar *)"br")) {
		[tempEntry appendString:@"<br/>"];
		return;
	} else if(xmlStrEqual(node->name, (const xmlChar *)"div")) {
		[self extractTextFromNode:node intoBuffer:tempAuthor];
		return;
	}

	int isLink = 0;
	if(xmlStrEqual(node->name, (const xmlChar *)"a")) {
		isLink = 1;

		for(xmlAttrPtr attr = node->properties; attr; attr = attr->next) {
			if(xmlStrEqual(attr->name, (const xmlChar *)"href")) {
				xmlChar *value = xmlNodeListGetString(node->doc, attr->children, 0);
				[tempEntry appendString:@"<a href=\""];
				[tempEntry appendString:[NSString stringWithUTF8String:(const char *)value]];
				[tempEntry appendString:@"\">"];
				xmlFree(value);
			}
		}
	}

	for(xmlNodePtr child = node->children; child; child = child->next) {
		[self processEntryNode:child];
	}

	if(isLink) {
		[tempEntry appendString:@"</a>"];
	}
}

- (void)processLiNode:(xmlNodePtr)node {
	tempEntry = [[NSMutableString alloc] init];
	tempAuthor = [[NSMutableString alloc] init];
	title = [[NSMutableString alloc] init];
	
	[self processEntryNode:node];
	
	EksiEntry *entry = [[EksiEntry alloc] init];
	[entry setContent:tempEntry];
	[entry setAuthorAndDateFromSignature:tempAuthor];
	[results addObject:entry];
	[entry release];
	
	[tempEntry release];
	[tempAuthor release];
}

@end
