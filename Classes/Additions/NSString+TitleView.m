//
//  NSString+TitleView.m
//  mayhos
//
//  Created by Can Berk Güder on 16/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "NSString+TitleView.h"

@implementation NSString (TitleView)

- (CGFloat)absoluteMinimumWidthForFont:(UIFont *)font {
	NSArray *parts = [self componentsSeparatedByString:@" "];
	NSUInteger words = [parts count];

	if(words == 0)
		return 0;

	CGFloat minWidth = CGFLOAT_MAX;

	for(int i = 1; i <= words; i++) {
		NSString *firstLine = [[parts subarrayWithRange:NSMakeRange(0, i)] componentsJoinedByString:@" "];
		NSString *secondLine = [[parts subarrayWithRange:NSMakeRange(i, words-i)] componentsJoinedByString:@" "];

		CGSize firstLineSize = [firstLine sizeWithFont:font];
		CGSize secondLineSize = [secondLine sizeWithFont:font];

		CGFloat width = MAX(firstLineSize.width, secondLineSize.width);

		if(minWidth > width) {
			minWidth = width;
		} else {
			break;
		}
	}

	return minWidth;
}

@end
