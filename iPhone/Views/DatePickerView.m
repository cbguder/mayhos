//
//  DatePickerView.m
//  mayhos
//
//  Created by Can Berk Güder on 9/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, pickerPos, frame.size.width, pickerHeight)];
		datePicker.datePickerMode = UIDatePickerModeDate;
		[self addSubview:datePicker];
		[datePicker release];

		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, pickerPos - 44.0, frame.size.width, 44.0)];
		toolbar.barStyle = UIBarStyleBlackTranslucent;
		[self addSubview:toolbar];
		[toolbar release];

		UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"İptal" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Tamam" style:UIBarButtonItemStyleDone target:self action:@selector(done)];

		toolbar.items = [NSArray arrayWithObjects:cancelItem, flexibleSpace, doneItem, nil];

		[cancelItem release];
		[flexibleSpace release];
		[doneItem release];
	}

	return self;
}

#pragma mark UIBarButtonItem Methods

- (void)cancel {
	[delegate datePickerCancelled:self];
	[self easeOutFromSuperview];
}

- (void)done {
	[delegate datePicker:self pickedDate:datePicker.date];
	[self easeOutFromSuperview];
}

- (void)setSelectedDate:(NSDate *)date {
	[datePicker setDate:date animated:NO];
}

@end
