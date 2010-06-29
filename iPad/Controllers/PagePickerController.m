//
//  PagePickerController.m
//  mayhos
//
//  Created by Can Berk Güder on 31/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "PagePickerController.h"

@interface PagePickerController ()
@property (nonatomic,retain) UISlider *slider;
@property (nonatomic,retain) UILabel *label;
@end

@implementation PagePickerController

@synthesize slider, label, currentPage, totalPages, delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithDelegate:(id)theDelegate {
	if(self = [super init]) {
		self.delegate = theDelegate;
	}

	return self;
}

#pragma mark -
#pragma mark Accessors

- (void)resetSlider {
	slider.maximumValue = totalPages;
	slider.value = currentPage;
	label.text = [NSString stringWithFormat:@"%d of %d", currentPage, totalPages];
}

- (void)setTotalPages:(NSUInteger)theTotalPages {
	totalPages = theTotalPages;
	[self resetSlider];
}

- (void)setCurrentPage:(NSUInteger)theCurrentPage {
	currentPage = theCurrentPage;
	[self resetSlider];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.contentSizeForViewInPopover = CGSizeMake(320, 58);

	self.slider = [[UISlider alloc] initWithFrame:CGRectMake(18, 25, 284, 23)];
	slider.minimumValue = 1;
	[slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
	[slider addTarget:self action:@selector(sliderDone) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:slider];
	[slider release];

	self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 280, 21)];
	label.font = [UIFont boldSystemFontOfSize:14];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:label];
	[label release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -

- (void)sliderValueChanged {
	self.currentPage = lroundf(slider.value);
}

- (void)sliderDone {
	if([delegate respondsToSelector:@selector(pagePickerController:pickedPage:)]) {
		[delegate pagePickerController:self pickedPage:currentPage];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	[super viewDidUnload];
	self.slider = nil;
	self.label = nil;
}

- (void)dealloc {
	[slider release];
	[super dealloc];
}

@end
