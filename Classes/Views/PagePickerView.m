//
//  PagePickerView.m
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "PagePickerView.h"

@implementation PagePickerView

@synthesize delegate;

- (void)setDelegate:(id<PagePickerDelegate>)aDelegate {
	delegate = aDelegate;

	pickerView.dataSource = delegate;
	pickerView.delegate = delegate;
}

- (id)initWithFrame:(CGRect)aRect {
	if(self = [super initWithFrame:aRect]) {
		self.backgroundColor = [UIColor clearColor];

		CGFloat pickerHeight = 216.0;
		if(aRect.size.width > aRect.size.height) {
			pickerHeight = 162.0;
		}
		CGFloat pickerPos = aRect.size.height - pickerHeight;
		totalHeight = pickerHeight + 44.0;

		pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, pickerPos, aRect.size.width, pickerHeight)];
		pickerView.showsSelectionIndicator = YES;
		[self addSubview:pickerView];
		[pickerView release];

		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, pickerPos - 44.0, aRect.size.width, 44.0)];
		toolbar.barStyle = UIBarStyleBlackTranslucent;
		[self addSubview:toolbar];
		[toolbar release];

		UIBarButtonItem *lastItem = [[UIBarButtonItem alloc] initWithTitle:@"Son" style:UIBarButtonItemStyleDone target:self action:@selector(last:)];
		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"İptal" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
		UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Tamam" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];

		toolbar.items = [NSArray arrayWithObjects:lastItem, flexibleSpace, cancelItem, doneItem, nil];

		[flexibleSpace release];
		[cancelItem release];
		[lastItem release];
		[doneItem release];

		[self setFrame:aRect];
	}

	return self;
}

- (void)setSelectedPage:(NSUInteger)page {
	[pickerView selectRow:page - 1 inComponent:0 animated:NO];
}

- (void)easeOutFromSuperview {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	[self setFrame:CGRectMake(0, totalHeight, self.frame.size.width, self.frame.size.height)];
	[UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[self removeFromSuperview];
}

#pragma mark UIBarButtonItem Methods

- (void)cancel:(id)sender {
	[self easeOutFromSuperview];
}

- (void)done:(id)sender {
	[delegate pagePicked:[pickerView selectedRowInComponent:0] + 1];
	[self easeOutFromSuperview];
}

- (void)last:(id)sender {
	NSUInteger lastPage = [pickerView numberOfRowsInComponent:0];
	[delegate pagePicked:lastPage];
	[self easeOutFromSuperview];
}

@end
