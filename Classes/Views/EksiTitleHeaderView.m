//
//  EksiTitleHeaderView.m
//  mayhos
//
//  Created by Can Berk Güder on 28/3/2009.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiTitleHeaderView.h"

@implementation EksiTitleHeaderView

@synthesize text;

- (id)initWithFrame:(CGRect)rect {
    if(self = [super initWithFrame:rect]) {
		self.contentMode = UIViewContentModeRedraw;
    }

    return self;
}

- (void)setFrame:(CGRect)rect {
	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16]
				   constrainedToSize:CGSizeMake(rect.size.width - 20.0, CGFLOAT_MAX)
					   lineBreakMode:UILineBreakModeWordWrap];

	[super setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, size.height + 20)];
}

- (void)setText:(NSString *)aText {
	if(![text isEqualToString:aText]) {
		[text release];
		text = [aText copy];
		[self setFrame:self.frame];
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	[textColor set];
	[text drawInRect:CGRectMake(10, 10, rect.size.width - 20, rect.size.height - 20)
			withFont:[UIFont boldSystemFontOfSize:16]
	   lineBreakMode:UILineBreakModeWordWrap];
}

- (void)dealloc {
	[text release];
	[super dealloc];
}

@end
