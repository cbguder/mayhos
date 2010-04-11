//
//  API.m
//  mayhos
//
//  Created by Can Berk Güder on 11/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "API.h"

@implementation API

+ (NSURL *)todayURL {
	return [NSURL URLWithString:[kSozlukURL stringByAppendingString:@"index.asp?a=td"]];
}

+ (NSURL *)yesterdayURL {
	return [NSURL URLWithString:[kSozlukURL stringByAppendingString:@"index.asp?a=yd"]];
}

+ (NSURL *)URLForSearchQuery:(NSString *)query {
	NSString *URLString = [kSozlukURL stringByAppendingFormat:@"index.asp?a=sr&kw=%@", urlEncode(query)];
	return [NSURL URLWithString:URLString];
}

+ (NSURL *)URLForTitle:(NSString *)title {
	NSString *URLString = [kSozlukURL stringByAppendingFormat:@"show.asp?t=%@", urlEncode(title)];
	return [NSURL URLWithString:URLString];
}

+ (NSURL *)URLForTitle:(NSString *)title withSearchQuery:(NSString *)query {
	NSString *URLString = [kSozlukURL stringByAppendingFormat:@"show.asp?t=%@&kw=%@", urlEncode(title), urlEncode(query)];
	return [NSURL URLWithString:URLString];
}

@end
