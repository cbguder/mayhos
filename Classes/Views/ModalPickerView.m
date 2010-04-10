//
//  ModalPickerView.m
//  mayhos
//
//  Created by Can Berk Güder on 9/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "ModalPickerView.h"

@implementation ModalPickerView

- (id)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];

		pickerHeight = 216.0;
		if(frame.size.width > frame.size.height) {
			pickerHeight = 162.0;
		}
		pickerPos = frame.size.height - pickerHeight;
		totalHeight = pickerHeight + 44.0;

		[self setFrame:frame];
	}

	return self;
}

- (void)easeOutFromSuperview {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	[self setFrame:CGRectMake(0, totalHeight, self.frame.size.width, self.frame.size.height)];
	[UIView commitAnimations];

	mayhosAppDelegate *appDelegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate unlockOrientation];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[self removeFromSuperview];
}

@end
