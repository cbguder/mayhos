//
//  EksiLink.m
//  mayhos
//
//  Created by Can Berk Güder on 15/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "EksiLink.h"

@implementation EksiLink

@synthesize title;
@synthesize URL;

+ (id)linkWithTitle:(NSString *)theTitle URL:(NSURL *)theURL {
	return [[[EksiLink alloc] initWithTitle:theTitle URL:theURL] autorelease];
}

- (id)init {
	return [self initWithTitle:nil URL:nil];
}

- (id)initWithTitle:(NSString *)theTitle URL:(NSURL *)theURL {
	if ((self = [super init])) {
		self.title = theTitle;
		self.URL = theURL;
	}

	return self;
}

@end
