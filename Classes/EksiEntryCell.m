//
//  EksiEntryCell.m
//  Eksi Sozluk
//
//  Created by Can Berk Güder on 29/3/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "EksiEntryCell.h"

@interface EksiEntryCellView : UIView
@end

@implementation EksiEntryCellView

- (void)drawRect:(CGRect)rect {
	[(EksiEntryCell *)[self superview] drawContentView:rect];
}

@end

@implementation EksiEntryCell

@synthesize entry;

- (void)setEntry:(EksiEntry *)newEntry {
	if(entry != newEntry) {
		[entry release];
		entry = [newEntry retain];
		[self setNeedsDisplay];
	}
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        contentView = [[EksiEntryCellView alloc] initWithFrame:CGRectZero];
		[contentView setOpaque:YES];
		[self addSubview:contentView];
		[contentView release];
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[entry release];
    [super dealloc];
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:rect];
	CGRect b = [self bounds];
	b.size.height -= 1; // leave room for the seperator line
	[contentView setFrame:b];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect {
	CGSize contentSize = [[entry content] sizeWithFont:[UIFont systemFontOfSize:14]
									 constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)
										 lineBreakMode:UILineBreakModeWordWrap];

	CGContextRef context = UIGraphicsGetCurrentContext();

	[[UIColor whiteColor] set];
	CGContextFillRect(context, rect);

	[[UIColor darkTextColor] set];

	CGRect contentRect = CGRectMake(10, 10, 300, contentSize.height);
	CGRect authorRect  = CGRectMake(10, contentSize.height + 28, 300, 20);

	[[entry content] drawInRect:contentRect
					   withFont:[UIFont systemFontOfSize:14]
				  lineBreakMode:UILineBreakModeWordWrap];

	NSString *authorText = [NSString stringWithFormat:@"%@, %@", [entry author], [entry dateString]];

	[authorText drawInRect:authorRect
				  withFont:[UIFont systemFontOfSize:14]
			 lineBreakMode:UILineBreakModeTailTruncation
				 alignment:UITextAlignmentRight];
}

@end
