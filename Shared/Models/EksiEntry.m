//
//  EksiEntry.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 29/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiEntry.h"

@implementation EksiEntry

@synthesize author, content, plainTextContent, date, lastEdit;

- (void) dealloc {
	[author release];
	[content release];
	[date release];
	[lastEdit release];

	[super dealloc];
}

- (void)setAuthorAndDateFromSignature:(NSString *)signature {
	if([signature length] <= 2) {
		return;
	}

	NSMutableCharacterSet *set = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
	[set addCharactersInString:@"()"];
	NSString *reduced = [signature stringByTrimmingCharactersInSet:set];
	[set release];
	NSArray *parts = [reduced componentsSeparatedByString:@", "];

	self.author = [parts objectAtIndex:0];

	NSArray *dateParts = [[parts objectAtIndex:1] componentsSeparatedByString:@" ~ "];
	if([dateParts count] == 1) {
		self.date = [EksiEntry parseDate:[dateParts objectAtIndex:0]];
		self.lastEdit = nil;
	} else if([dateParts count] > 1) {
		self.date = [EksiEntry parseDate:[dateParts objectAtIndex:0]];
		self.lastEdit = [EksiEntry parseDate:[dateParts objectAtIndex:1] withBaseDate:[dateParts objectAtIndex:0]];
	}
}

#pragma mark Properties

- (NSString *)dateString {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

	if(lastEdit == nil || [date isEqualToDate:lastEdit]) {
		return [dateFormatter stringFromDate:date];
	} else {
		long dnDate = (long) floor(([date timeIntervalSinceReferenceDate] + [[NSTimeZone localTimeZone] secondsFromGMTForDate:date]) / (double)(60*60*24));
		long dnLastEdit = (long) floor(([lastEdit timeIntervalSinceReferenceDate] + [[NSTimeZone localTimeZone] secondsFromGMTForDate:lastEdit]) / (double)(60*60*24));

		if(dnDate == dnLastEdit) {
			NSString *result = [dateFormatter stringFromDate:date];
			[dateFormatter setDateStyle:NSDateFormatterNoStyle];
			return [result stringByAppendingFormat:@" ~ %@", [dateFormatter stringFromDate:lastEdit]];
		} else {
			return [NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:date], [dateFormatter stringFromDate:lastEdit]];
		}
	}
}

- (NSString *)signature {
	return [NSString stringWithFormat:@"%@, %@", author, [self dateString]];
}

#pragma mark Class Methods

+ (NSDate *)parseDate:(NSString *)theDate {
	return [self parseDate:theDate withBaseDate:nil];
}

+ (NSDate *)parseDate:(NSString *)theDate withBaseDate:(NSString *)theBaseDate {
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"tr_TR"] autorelease];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setLocale:locale];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Istanbul"]];

	if([theDate length] == 5) {
		if(theBaseDate == nil) {
			[dateFormatter setDateStyle:NSDateFormatterNoStyle];
			return [dateFormatter dateFromString:theDate];
		} else {
			theDate = [NSString stringWithFormat:@"%@ %@", [theBaseDate substringToIndex:10], theDate];
			return [dateFormatter dateFromString:theDate];
		}
	} else if([theDate length] == 10) {
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		return [dateFormatter dateFromString:theDate];
	} else if([theDate length] == 16) {
		return [dateFormatter dateFromString:theDate];
	}

	return nil;
}

@end
