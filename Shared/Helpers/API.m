//
//  API.m
//  mayhos
//
//  Created by Can Berk Güder on 11/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "API.h"
#import "NSDictionary+URLEncoding.h"

@implementation API

+ (NSURL *)newsURL {
	return [API URLForPath:@"/news.asp"];
}

+ (NSURL *)todayURL {
	return [API URLForPath:@"/index.asp?a=td"];
}

+ (NSURL *)yesterdayURL {
	return [API URLForPath:@"/index.asp?a=yd"];
}

+ (NSURL *)randomURL {
	return [API URLForPath:@"/index.asp?a=rn"];
}

+ (NSURL *)featuredURL {
	return [API URLForPath:@"/pick.asp?p=g"];
}

+ (NSURL *)activeURL {
	return [API URLForPath:@"/index.asp?a=he"];
}

+ (NSURL *)URLForDate:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd.MM.YYYY"];
	NSString *dateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];

	NSString *path = [NSString stringWithFormat:@"/index.asp?a=rd&d=%@", urlEncode(dateString)];
	return [API URLForPath:path];
}

+ (NSURL *)URLForSearchQuery:(NSString *)query {
	NSString *path = [NSString stringWithFormat:@"/index.asp?a=sr&kw=%@", urlEncode(query)];
	return [API URLForPath:path];
}

+ (NSURL *)URLForAdvancedSearchQuery:(NSString *)query author:(NSString *)author sortCriteria:(SortCriteria)sortCriteria date:(NSDate *)date guzel:(BOOL)guzel {
	NSMutableDictionary *searchDictionary = [NSMutableDictionary dictionary];
	[searchDictionary setObject:@"sr" forKey:@"a"];

	if (query) {
		[searchDictionary setObject:query forKey:@"kw"];
	}

	if (author) {
		[searchDictionary setObject:author forKey:@"au"];
	}

	if (sortCriteria == SortAlphabetically) {
		[searchDictionary setObject:@"a" forKey:@"so"];
	} else if (sortCriteria == SortByDate) {
		[searchDictionary setObject:@"y" forKey:@"so"];
	} else if (sortCriteria == SortRandom) {
		[searchDictionary setObject:@"r" forKey:@"so"];
	} else if (sortCriteria == SortGudik) {
		[searchDictionary setObject:@"g" forKey:@"so"];
	}

	if (date) {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
		[gregorian release];

		[searchDictionary setObject:[NSNumber numberWithInteger:dateComponents.day] forKey:@"fd"];
		[searchDictionary setObject:[NSNumber numberWithInteger:dateComponents.month] forKey:@"fm"];
		[searchDictionary setObject:[NSNumber numberWithInteger:dateComponents.year] forKey:@"fy"];
	}

	if (guzel) {
		[searchDictionary setObject:@"y" forKey:@"cr"];
	}

	NSString *path = [NSString stringWithFormat:@"/index.asp?%@", [searchDictionary urlEncodedString]];
	return [API URLForPath:path];
}

+ (NSURL *)URLForTitle:(NSString *)title {
	NSString *path = [NSString stringWithFormat:@"/show.asp?t=%@", urlEncode(title)];
	return [API URLForPath:path];
}

+ (NSURL *)URLForTitle:(NSString *)title withSearchQuery:(NSString *)query {
	NSString *path = [NSString stringWithFormat:@"/show.asp?t=%@&kw=%@", urlEncode(title), urlEncode(query)];
	return [API URLForPath:path];
}

+ (NSURL *)URLForPath:(NSString *)path {
	NSString *URLString = [kSozlukURL stringByAppendingString:path];
	return [NSURL URLWithString:URLString];
}

@end
