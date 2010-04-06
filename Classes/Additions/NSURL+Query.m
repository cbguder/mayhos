//
//  NSURL+Query.m
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "NSURL+Query.h"

@implementation NSURL (Query)

- (NSMutableDictionary *)queryDictionary {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

	if([self query]) {
		NSScanner *scanner = [NSScanner scannerWithString:[self query]];
		NSString *key;
		NSString *value;

		while(![scanner isAtEnd]) {
			if(![scanner scanUpToString:@"=" intoString:&key]) key = nil;
			[scanner scanString:@"=" intoString:nil];
			if(![scanner scanUpToString:@"&" intoString:&value]) value = nil;
			[scanner scanString:@"&" intoString:nil];

			key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

			if(key) {
				[dictionary setValue:value forKey:key];
			}
		}
	}

	return dictionary;
}

@end
