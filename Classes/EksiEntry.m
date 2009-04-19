//
//  EksiEntry.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiEntry.h"

@implementation EksiEntry

#pragma mark Initialization Methods

- (id)initWithAuthor:(NSString *)theAuthor content:(NSString *)theContent date:(NSDate *)theDate lastEdit:(NSDate *)theLastEdit {
	[super init];
	[self setAuthor:theAuthor];
	[self setContent:theContent];
	[self setDate:theDate];
	[self setLastEdit:theLastEdit];
	
	return self;
}

- (void) dealloc {
	[author release];
	[content release];
	[date release];
	[lastEdit release];
	
	[super dealloc];
}

#pragma mark Accessors

@synthesize author;
@synthesize content;
@synthesize date;
@synthesize lastEdit;

- (NSString *)dateString {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	if (lastEdit == nil || [date isEqualToDate:lastEdit]) {
		return [dateFormatter stringFromDate:date];
	} else {
		long dnDate     = (long) floor(([date timeIntervalSinceReferenceDate] + [[NSTimeZone localTimeZone] secondsFromGMTForDate:date]) / (double)(60*60*24));
		long dnLastEdit = (long) floor(([lastEdit timeIntervalSinceReferenceDate] + [[NSTimeZone localTimeZone] secondsFromGMTForDate:lastEdit]) / (double)(60*60*24));

		if (dnDate == dnLastEdit) {
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
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"tr_TR"]];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Istanbul"]];
	
	if ([theDate length] == 5) {
		if (theBaseDate == nil) {
			[dateFormatter setDateStyle:NSDateFormatterNoStyle];
			return [dateFormatter dateFromString:theDate];
		} else {
			theDate = [NSString stringWithFormat:@"%@ %@", [theBaseDate substringToIndex:10], theDate];
			return [dateFormatter dateFromString:theDate];
		}
	} else if ([theDate length] == 10) {
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		return [dateFormatter dateFromString:theDate];
	} else if ([theDate length] == 16) {
		return [dateFormatter dateFromString:theDate];
	}
	
	return nil;
}

@end
