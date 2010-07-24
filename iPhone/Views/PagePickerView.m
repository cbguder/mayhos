//
//  PagePickerView.m
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import "PagePickerView.h"

@implementation PagePickerView

@synthesize numberOfPages;
@synthesize currentPage;
@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, pickerPos, frame.size.width, pickerHeight)];
		pickerView.showsSelectionIndicator = YES;
		pickerView.dataSource = self;
		pickerView.delegate = self;
		[self addSubview:pickerView];
		[pickerView release];

		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, pickerPos - 44.0, frame.size.width, 44.0)];
		toolbar.barStyle = UIBarStyleBlackTranslucent;
		[self addSubview:toolbar];
		[toolbar release];

		UIBarButtonItem *lastItem = [[UIBarButtonItem alloc] initWithTitle:@"Son" style:UIBarButtonItemStyleDone target:self action:@selector(last)];
		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"İptal" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
		UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Tamam" style:UIBarButtonItemStyleDone target:self action:@selector(done)];

		toolbar.items = [NSArray arrayWithObjects:lastItem, flexibleSpace, cancelItem, doneItem, nil];

		[flexibleSpace release];
		[cancelItem release];
		[lastItem release];
		[doneItem release];
	}

	return self;
}

- (void)layoutSubviews {
	pickerView.frame = CGRectMake(0.0, pickerPos, self.frame.size.width, pickerHeight);
	toolbar.frame = CGRectMake(0.0, pickerPos - 44.0, self.frame.size.width, 44.0);
}

#pragma mark -
#pragma mark Accessors

- (void)setCurrentPage:(NSUInteger)number {
	currentPage = number;
	[pickerView selectRow:currentPage - 1 inComponent:0 animated:NO];
}

- (void)setNumberOfPages:(NSUInteger)number {
	numberOfPages = number;
	[pickerView reloadAllComponents];
}

#pragma mark -
#pragma mark Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return numberOfPages;
}

#pragma mark -
#pragma mark Picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%d", row + 1];
}

#pragma mark -
#pragma mark Toolbar buttons

- (void)cancel {
	[self easeOutFromSuperview];
}

- (void)done {
	[delegate pagePicker:self pickedPage:[pickerView selectedRowInComponent:0] + 1];
	[self easeOutFromSuperview];
}

- (void)last {
	[delegate pagePicker:self pickedPage:numberOfPages];
	[self easeOutFromSuperview];
}

@end
