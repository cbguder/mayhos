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
