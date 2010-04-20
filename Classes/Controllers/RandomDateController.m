//
//  RandomDateController.m
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RandomDateController.h"

@interface RandomDateController (Private)
- (void)shuffle;
- (void)randomizeDate;
@end

@implementation RandomDateController

@synthesize shuffleItem;

- (void)viewDidLoad {
	self.shuffleItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Shuffle-Small.png"]
														style:UIBarButtonItemStyleBordered
													   target:self
													   action:@selector(shuffle)];
	self.navigationItem.leftBarButtonItem = shuffleItem;
	[shuffleItem release];

	[self randomizeDate];
	[super viewDidLoad];
}

- (void)dealloc {
	[shuffleItem release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.shuffleItem = nil;
	[super viewDidUnload];
}

- (void)shuffle {
	[self randomizeDate];
	[self loadURL];
}

- (void)randomizeDate {
	NSDate *date = randomDate();
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	self.navigationItem.title = [[dateFormatter stringFromDate:date] lowercaseString];
	[dateFormatter release];
	
	self.URL = [API URLForDate:date];
}

@end
