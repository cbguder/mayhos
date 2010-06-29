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

	CGRect initialFrame, finalFrame;

	if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
		initialFrame = CGRectMake(0, 260, 320, 480);
		finalFrame = CGRectMake(0, 0, 320, 480);
	} else {
		initialFrame = CGRectMake(0, 206, 480, 320);
		finalFrame = CGRectMake(0, 0, 480, 320);
	}

	modalPickerView.frame = initialFrame;

	UIView *parentView = [UIAppDelegatePhone.window.subviews objectAtIndex:0];
	[parentView addSubview:modalPickerView];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[modalPickerView setFrame:finalFrame];
	[UIView commitAnimations];
}

@end
