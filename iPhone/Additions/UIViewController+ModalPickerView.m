//
//  UIViewController+ModalPickerView.m
//  mayhos
//
//  Created by Can Berk Güder on 7/6/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "UIViewController+ModalPickerView.h"

@implementation UIViewController (ModalPickerView)

- (void)presentModalPickerView:(ModalPickerView *)modalPickerView {
	[UIAppDelegatePhone lockOrientation:self.interfaceOrientation];

	UIView *parentView = [UIAppDelegatePhone.window.subviews objectAtIndex:0];
    CGFloat height = parentView.bounds.size.height;
    CGFloat width = parentView.bounds.size.width;

	CGRect initialFrame, finalFrame;

	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
		initialFrame = CGRectMake(0, 260, width, height);
		finalFrame = CGRectMake(0, 0, width, height);
	} else {
		initialFrame = CGRectMake(0, 206, width, height);
		finalFrame = CGRectMake(0, 0, width, height);
	}

	modalPickerView.frame = initialFrame;

	[parentView addSubview:modalPickerView];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[modalPickerView setFrame:finalFrame];
	[UIView commitAnimations];
}

@end
