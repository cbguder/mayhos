//
//  PagePickerView.m
//  Eksi Sozluk
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "PagePickerView.h"

@implementation PagePickerView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];

		UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 220, 320, 44)];
		toolbar.barStyle = UIBarStyleBlackTranslucent;
		[self addSubview:toolbar];
		[toolbar release];

		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
		UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];

		toolbar.items = [NSArray arrayWithObjects:flexibleSpace, cancelItem, doneItem, nil];

		[flexibleSpace release];
		[cancelItem release];
		[doneItem release];

		pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 264, 0, 0)];
		pickerView.showsSelectionIndicator = YES;
		[self addSubview:pickerView];
		[pickerView release];
    }

    return self;
}

- (void)setDelegate:(id<PagePickerDelegate>)aDelegate {
	delegate = aDelegate;

	pickerView.dataSource = delegate;
	pickerView.delegate = delegate;
}

- (void)setSelectedPage:(NSUInteger)page {
	[pickerView selectRow:page - 1 inComponent:0 animated:NO];
}

- (void)cancel:(id)sender {
	[self removeFromSuperview];
}

- (void)done:(id)sender {
	[self removeFromSuperview];
	if(delegate != nil && [delegate respondsToSelector:@selector(pagePicked:)]) {
		[delegate pagePicked:[pickerView selectedRowInComponent:0]];
	}
}

- (void)dealloc {
    [super dealloc];
}

@end
