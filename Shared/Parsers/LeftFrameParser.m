//
//  LeftFrameParser.m
//  mayhos
//
//  Created by Can Berk Güder on 8/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "LeftFrameParser.h"
#import "EksiLink.h"
#import "RegexKitLite.h"

@interface LeftFrameParser (Private)
- (void)processNode:(xmlNodePtr)node;
- (void)processANode:(xmlNodePtr)node;
- (void)processTextNode:(xmlNodePtr)node;
@end

@implementation LeftFrameParser

- (id)initWithURL:(NSURL *)theURL delegate:(id<EksiParserDelegate>)theDelegate {
	if ((self = [super initWithURL:theURL delegate:theDelegate])) {
		whitespaceCharacterSet = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
		[whitespaceCharacterSet addCharactersInRange:NSMakeRange(160, 1)];
	}

	return self;
}

- (void)dealloc {
	[whitespaceCharacterSet release];
	[super dealloc];
}

- (void)parseDocument {
	[super parseDocument];
	[self processNode:root];
}

#pragma mark Node Processing Methods

- (void)processNode:(xmlNodePtr)node {
	while (node) {
		if (node->type == XML_ELEMENT_NODE) {
			if (xmlStrEqual(node->name, (const xmlChar *)"a")) {
				[self processANode:node];
			}

			[self processNode:node->children];
		} else if (node->type == XML_TEXT_NODE) {
			[self processTextNode:node];
		}

		node = node->next;
	}
}

- (void)processANode:(xmlNodePtr)node {
	for (xmlAttrPtr attr = node->properties; attr; attr = attr->next) {
		if (xmlStrEqual(attr->name, (const xmlChar *)"href")) {
			xmlChar *value = xmlNodeListGetString(node->doc, attr->children, YES);
			NSString *theURL = [NSString stringWithUTF8String:(const char *)value];
			xmlFree(value);

			if ([theURL hasPrefix:@"show.asp"]) {
				EksiLink *link = [[EksiLink alloc] init];

				xmlChar *value = xmlNodeListGetString(node->doc, node->children, YES);
				link.title = [NSString stringWithUTF8String:(const char *)value];
				xmlFree(value);

				link.URL = [NSURL URLWithString:theURL relativeToURL:URL];

				[results addObject:link];
				[link release];
			}
		}
	}
}

- (void)processTextNode:(xmlNodePtr)node {
	xmlChar *value = xmlNodeGetContent(node);
	NSString *theText = [[NSString stringWithUTF8String:(const char *)value] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
	xmlFree(value);

	NSRange range = [theText rangeOfRegex:@"\\(\\d+\\)"];
	if (range.location != NSNotFound) {
		NSInteger number = [[theText substringWithRange:NSMakeRange(range.location + 1, range.length - 2)] integerValue];

		if (number > 0) {
			EksiLink *lastLink = [results lastObject];
			lastLink.entryCount = number;
		}
	}
}

@end
