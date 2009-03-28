//
//  EksiTitleHeaderView.m
//  Eksi Sozluk
//
//  Created by Can Berk Güder on 28/3/2009.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiTitleHeaderView.h"

@implementation EksiTitleHeaderView

@synthesize text;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [[UIColor groupTableViewBackgroundColor] CGColor]);
	CGContextFillRect(context, rect);

	CGContextSetFillColorWithColor(context, [[UIColor darkTextColor] CGColor]);
	CGContextFillRect(context, CGRectMake(rect.origin.x - 0.5, rect.origin.y + rect.size.height - 0.5, rect.size.width , 1.0));

	if(text != nil) {
		[text drawInRect:CGRectMake(rect.origin.x + 10, rect.origin.y + 10, rect.size.width - 20, rect.size.height - 20)
				withFont:[UIFont boldSystemFontOfSize:16]
		   lineBreakMode:UILineBreakModeWordWrap];
	}	
}

- (void)dealloc {
	[text release];

    [super dealloc];
}

@end
