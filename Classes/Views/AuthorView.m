//
//  AuthorView.m
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "AuthorView.h"

@implementation AuthorView

- (void)setAuthor:(NSString *)anAuthor {
	if(![author isEqualToString:anAuthor]) {
		[author release];
		author = [anAuthor copy];
		[self setNeedsDisplay];
	}
}

- (void)setDate:(NSString *)aDate {
	if(![date isEqualToString:aDate]) {
		[date release];
		date = [aDate copy];
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	[textColor set];
	[author drawInRect:CGRectMake(10, 10, rect.size.width - 20, 20) withFont:[UIFont boldSystemFontOfSize:16]];
	[date drawInRect:CGRectMake(10, 30, rect.size.width - 20, 20) withFont:[UIFont systemFontOfSize:12]];
}

- (void)dealloc {
	[author release];
	[date release];
	[super dealloc];
}

@end
