//
//  Util.m
//  mayhos
//
//  Created by Can Berk Güder on 11/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "Util.h"

NSString *toString(id object) {
	return [NSString stringWithFormat: @"%@", object];
}

NSString *urlEncode(id object) {
	NSString *string = toString(object);
	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, CFSTR("￼=,!$&'()*;@?\n\"<>#\t :/"), kCFStringEncodingUTF8) autorelease];
}

NSDate *randomDate() {
	int min = 10637; // 15.02.1999
	int max = ([[NSDate date] timeIntervalSince1970] / 86400) - 2; // 2 days ago

	sranddev();
	int r = min + rand() % (max - min);

	return [NSDate dateWithTimeIntervalSince1970:86400*r];
}
