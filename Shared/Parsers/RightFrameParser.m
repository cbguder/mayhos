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
- (void)processEntryNode:(xmlNodePtr)node intoAuthorBuffer:(NSMutableString *)authorBuffer entryBuffer:(NSMutableString *)entryBuffer;
- (void)processLiNode:(xmlNodePtr)node;

- (void)extractTextFromNode:(xmlNodePtr)node intoBuffer:(NSMutableString *)buffer;
- (void)extractEntryPlainTextFromNode:(xmlNodePtr)node intoBuffer:(NSMutableString *)buffer;
- (NSInteger)extractIntegerFromNode:(xmlNodePtr)node property:(const xmlChar *)property;
@end

@implementation RightFrameParser

@synthesize title, hasMoreToLoad, moreURL;

- (id)initWithURL:(NSURL *)theURL delegate:(id<EksiParserDelegate>)theDelegate {
	if ((self = [super initWithURL:theURL delegate:theDelegate])) {
		title = [[NSMutableString alloc] init];
		hasMoreToLoad = NO;
	}

	return self;
}

- (void)dealloc {
	[title release];
	[moreURL release];

	[super dealloc];
}

- (void)parseDocument {
	[super parseDocument];
	[self processNode:root];
}

- (void)extractTextFromNode:(xmlNodePtr)node intoBuffer:(NSMutableString *)buffer {
	if (node->type == XML_TEXT_NODE) {
		[buffer appendString:[NSString stringWithUTF8String:(const char *)node->content]];
	} else {
		for (xmlNodePtr child = node->children; child; child = child->next) {
			[self extractTextFromNode:child intoBuffer:buffer];
		}
	}
}

- (void)extractEntryPlainTextFromNode:(xmlNodePtr)node intoBuffer:(NSMutableString *)buffer {
	if (node->type == XML_TEXT_NODE) {
		[buffer appendString:[NSString stringWithUTF8String:(const char *)node->content]];
	} else if (xmlStrEqual(node->name, (const xmlChar *)"br")) {
		[buffer appendString:@"\n"];
	} else if (!xmlStrEqual(node->name, (const xmlChar *)"div")) {
		for (xmlNodePtr child = node->children; child; child = child->next) {
			[self extractEntryPlainTextFromNode:child intoBuffer:buffer];
		}
	}
}

- (NSInteger)extractIntegerFromNode:(xmlNodePtr)node property:(const xmlChar *)property {
	xmlChar *value = xmlGetProp(node, property);
	NSString *str = nil;

	if (value) {
		str = [NSString stringWithUTF8String:(const char *)value];
		xmlFree(value);
	}

	return [str integerValue];
}

#pragma mark Node Processing Methods

- (void)processNode:(xmlNodePtr)node {
	while (node) {
		if (node->type == XML_ELEMENT_NODE) {
			if (xmlStrEqual(node->name, (const xmlChar *)"li")) {
				[self processLiNode:node];
			} else if (xmlStrEqual(node->name, (const xmlChar *)"h1")) {
				[self extractTextFromNode:node intoBuffer:title];
			} else if (xmlStrEqual(node->name, (const xmlChar *)"button")) {
				[self processButtonNode:node];
			} else {
				[self processNode:node->children];
			}
		}

		node = node->next;
	}
}

- (void)processButtonNode:(xmlNodePtr)node {
	xmlChar *value = xmlNodeListGetString(node->doc, node->children, YES);

	if (xmlStrEqual(value, (const xmlChar *)"tümünü göster")) {
		for (xmlAttrPtr attr = node->properties; attr; attr = attr->next) {
			if (xmlStrEqual(attr->name, (const xmlChar *)"onclick")) {
				xmlChar *attrValue = xmlNodeListGetString(node->doc, attr->children, YES);
				NSString *onclick = [NSString stringWithUTF8String:(const char *)attrValue];
				xmlFree(attrValue);

				if ([onclick hasPrefix:@"location.href='"] && [onclick hasSuffix:@"'"]) {
					hasMoreToLoad = YES;
					moreURL = [[NSURL alloc] initWithString:
							   [kSozlukURL stringByAppendingFormat:@"/%@", [onclick substringWithRange:NSMakeRange(15, onclick.length - 16)]]
							   ];
				}
			}
		}
	}

	xmlFree(value);
}

- (void)processEntryNode:(xmlNodePtr)node intoAuthorBuffer:(NSMutableString *)authorBuffer entryBuffer:(NSMutableString *)entryBuffer {
	if (node->type == XML_TEXT_NODE) {
		[entryBuffer appendString:[NSString stringWithUTF8String:(const char *)node->content]];
		return;
	}

	if (node->type != XML_ELEMENT_NODE) {
		return;
	}

	if (xmlStrEqual(node->name, (const xmlChar *)"br")) {
		[entryBuffer appendString:@"<br/>"];
		return;
	} else if (xmlStrEqual(node->name, (const xmlChar *)"div")) {
		[self extractTextFromNode:node intoBuffer:authorBuffer];
		return;
	}

	int isLink = 0;
	if (xmlStrEqual(node->name, (const xmlChar *)"a")) {
		isLink = 1;

		for (xmlAttrPtr attr = node->properties; attr; attr = attr->next) {
			if (xmlStrEqual(attr->name, (const xmlChar *)"href")) {
				xmlChar *value = xmlNodeListGetString(node->doc, attr->children, YES);
				NSString *URLString = [NSString stringWithUTF8String:(const char *)value];
				BOOL internalLink = [URLString hasPrefix:@"show.asp"] || [URLString hasPrefix:@"index.asp"];

				[entryBuffer appendString:@"<a href=\""];

				if (internalLink)
					[entryBuffer appendString:@"mayhos://"];

				[entryBuffer appendString:URLString];

				if (internalLink)
					[entryBuffer appendString:@"\" class=\"internal"];

				[entryBuffer appendString:@"\">"];
				xmlFree(value);
			}
		}
	}

	for (xmlNodePtr child = node->children; child; child = child->next) {
		[self processEntryNode:child intoAuthorBuffer:authorBuffer entryBuffer:entryBuffer];
	}

	if (isLink) {
		[entryBuffer appendString:@"</a>"];
	}
}

- (void)processLiNode:(xmlNodePtr)node {
	NSMutableString *tempPlainTextContent = [[NSMutableString alloc] init];
	NSMutableString *tempEntry = [[NSMutableString alloc] init];
	NSMutableString *tempAuthor = [[NSMutableString alloc] init];

	NSInteger order = [self extractIntegerFromNode:node property:(const xmlChar *)"value"];

	[self processEntryNode:node intoAuthorBuffer:tempAuthor entryBuffer:tempEntry];
	[self extractEntryPlainTextFromNode:node intoBuffer:tempPlainTextContent];

	EksiEntry *entry = [[EksiEntry alloc] init];
	[entry setOrder:order];
	[entry setContent:tempEntry];
	[entry setPlainTextContent:tempPlainTextContent];
	[entry setAuthorAndDateFromSignature:tempAuthor];
	[results addObject:entry];
	[entry release];

	[tempPlainTextContent release];
	[tempEntry release];
	[tempAuthor release];
}

@end
