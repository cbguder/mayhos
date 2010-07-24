//
//  LeftFrameParser.m
//  mayhos
//
//  Created by Can Berk Güder on 8/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "LeftFrameParser.h"
#import "EksiLink.h"

@interface LeftFrameParser (Private)
- (void)processNode:(xmlNodePtr)node;
- (void)processANode:(xmlNodePtr)node;
@end

@implementation LeftFrameParser

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

@end
