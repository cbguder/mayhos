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

+ (NSURL *)todayURL {
	return [NSURL URLWithString:[kSozlukURL stringByAppendingString:@"index.asp?a=td"]];
}

+ (NSURL *)yesterdayURL {
	return [NSURL URLWithString:[kSozlukURL stringByAppendingString:@"index.asp?a=yd"]];
}

+ (NSURL *)randomURL {
	return [NSURL URLWithString:[kSozlukURL stringByAppendingString:@"index.asp?a=rn"]];
}

+ (NSURL *)featuredURL {
	return [NSURL URLWithString:[kSozlukURL stringByAppendingString:@"pick.asp?p=g"]];
}

+ (NSURL *)URLForDate:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd.MM.YYYY"];
	NSString *dateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];

	NSString *URLString = [kSozlukURL stringByAppendingFormat:@"index.asp?a=rd&d=%@", urlEncode(dateString)];
	return [NSURL URLWithString:URLString];
}

+ (NSURL *)URLForSearchQuery:(NSString *)query {
	NSString *URLString = [kSozlukURL stringByAppendingFormat:@"index.asp?a=sr&kw=%@", urlEncode(query)];
	return [NSURL URLWithString:URLString];
}

+ (NSURL *)URLForAdvancedSearchQuery:(NSString *)query author:(NSString *)author sortCriteria:(SortCriteria)sortCriteria date:(NSDate *)date guzel:(BOOL)guzel {
	NSMutableDictionary *searchDictionary = [NSMutableDictionary dictionary];
	[searchDictionary setObject:@"sr" forKey:@"a"];

	if(query) {
		[searchDictionary setObject:query forKey:@"kw"];
	}

	if(author) {
		[searchDictionary setObject:author forKey:@"au"];
	}

	if(sortCriteria == SortAlphabetically) {
		[searchDictionary setObject:@"a" forKey:@"so"];
	} else if(sortCriteria == SortByDate) {
		[searchDictionary setObject:@"y" forKey:@"so"];
	} else if(sortCriteria == SortRandom) {
		[searchDictionary setObject:@"r" forKey:@"so"];
	} else if(sortCriteria == SortGudik) {
		[searchDictionary setObject:@"g" forKey:@"so"];
	}

	if(date) {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
		[gregorian release];

		[searchDictionary setObject:[NSNumber numberWithInteger:dateComponents.day] forKey:@"fd"];
		[searchDictionary setObject:[NSNumber numberWithInteger:dateComponents.month] forKey:@"fm"];
		[searchDictionary setObject:[NSNumber numberWithInteger:dateComponents.year] forKey:@"fy"];
	}

	if(guzel) {
		[searchDictionary setObject:@"y" forKey:@"cr"];
	}

	NSString *URLString = [kSozlukURL stringByAppendingFormat:@"index.asp?%@", [searchDictionary urlEncodedString]];
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
