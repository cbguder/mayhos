//
//  TitleView.m
//  mayhos
//
//  Created by Can Berk Güder on 15/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "TitleView.h"
#import "NSString+TitleView.h"

#define kBarrier 400.0f
#define kMaxFontSizePortrait 20.0f
#define kMaxFontSizeLandscape 16.0f
#define kMinFontSize 13.0f

@implementation TitleView

- (void)adjustFontSize {
	if(!self.superview)
		return;

	CGFloat initialSize = self.superview.frame.size.width > kBarrier ? kMaxFontSizeLandscape : kMaxFontSizePortrait;
	CGFloat actualSize;

	[label.text sizeWithFont:[UIFont boldSystemFontOfSize:initialSize]
				 minFontSize:kMinFontSize
			  actualFontSize:&actualSize
					forWidth:label.frame.size.width
			   lineBreakMode:label.lineBreakMode];
	label.font = [UIFont boldSystemFontOfSize:actualSize];
}

- (id)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.textAlignment = UITextAlignmentCenter;

		[self addSubview:label];
	}

	return self;
}

- (NSString *)text {
	return label.text;
}

- (void)setText:(NSString *)text {
	label.text = text;
	[self setNeedsLayout];
}

- (void)layoutSubviews {
	UIFont *minFont = [UIFont boldSystemFontOfSize:kMinFontSize];

	CGFloat left = self.frame.origin.x;
	CGFloat right = self.superview.frame.size.width - (left + self.frame.size.width);
	CGFloat labelWidth = self.superview.frame.size.width - 2*MAX(left, right);
	CGFloat minWidth;

	if(self.superview.frame.size.width > kBarrier) {
		label.numberOfLines = 1;
		minWidth = [label.text sizeWithFont:minFont].width;
	} else {
		label.numberOfLines = 2;
		minWidth = [label.text absoluteMinimumWidthForFont:minFont];
	}

	if(labelWidth < minWidth) {
		labelWidth = MIN(minWidth, self.frame.size.width);
	}

	CGFloat labelX = 0;
	if(right > left)
		labelX = self.frame.size.width - labelWidth;

	label.frame = CGRectMake(labelX, 0, labelWidth, self.frame.size.height);
	[self adjustFontSize];
}

- (void)dealloc {
	[label release];
	[super dealloc];
}

@end
