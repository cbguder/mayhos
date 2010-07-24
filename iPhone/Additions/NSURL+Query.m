//
//  NSURL+Query.m
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "NSURL+Query.h"
#import "NSDictionary+URLEncoding.h"

@implementation NSURL (Query)

- (NSMutableDictionary *)queryDictionary {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

	if ([self query]) {
		NSScanner *scanner = [NSScanner scannerWithString:[self query]];
		NSString *key;
		NSString *value;

		while (![scanner isAtEnd]) {
			if (![scanner scanUpToString:@"=" intoString:&key]) key = nil;
			[scanner scanString:@"=" intoString:nil];
			if (![scanner scanUpToString:@"&" intoString:&value]) value = nil;
			[scanner scanString:@"&" intoString:nil];

			key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

			if (key != nil && value != nil) {
				[dictionary setObject:value forKey:key];
			}
		}
	}

	return dictionary;
}

- (NSURL *)URLBySettingQueryDictionary:(NSDictionary *)dictionary {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@?%@", [self scheme], [self host], [self path], [dictionary urlEncodedString]]];
}

- (NSURL *)normalizedURL {
	NSMutableDictionary *queryDictionary = [self queryDictionary];
	[queryDictionary removeObjectForKey:@"p"];
	return [self URLBySettingQueryDictionary:queryDictionary];
}

@end
