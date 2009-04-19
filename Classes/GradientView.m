//
//  GradientView.m
//  Eksi Sozluk
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		textColor = [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.00] retain];
	}

	return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
	
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 0.90, 0.90, 0.90, 1.00,   // Start color
	                          0.65, 0.65, 0.65, 1.00 }; // End color
	
	CGRect currentFrame  = self.frame;
	CGPoint topCenter    = CGPointMake(CGRectGetMidX(currentFrame), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentFrame), currentFrame.size.height);
	
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	CGContextDrawLinearGradient(context, gradient, topCenter, bottomCenter, 0);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(rgbColorspace);
	
	[[UIColor darkTextColor] set];
	CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - 0.5, rect.size.width, 1.0));
}

- (void)dealloc {
	[textColor release];
	[super dealloc];
}

@end
