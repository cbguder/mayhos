//
//  NSDictionary+URLEncoding.m
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "NSDictionary+URLEncoding.h"

@implementation NSDictionary (URLEncoding)

- (NSString*)urlEncodedString {
	NSMutableArray *parts = [NSMutableArray array];

	for(id key in self) {
		id value = [self objectForKey: key];
		NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
		[parts addObject: part];
	}

	return [parts componentsJoinedByString: @"&"];
}

@end
