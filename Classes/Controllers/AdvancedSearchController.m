//
//  AdvancedSearchController.m
//  mayhos
//
//  Created by Can Berk Güder on 22/3/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "AdvancedSearchController.h"
#import "DatePickerView.h"
#import "API.h"

@implementation AdvancedSearchController

@synthesize cancelItem, searchItem, queryField, authorField, guzelSwitch, sortOptions, selectedDate;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
	if(self = [super initWithStyle:style]) {
		self.sortOptions = [NSArray arrayWithObjects:@"alfa - beta", @"yeni - eski", @"rerörerö", @"gudik", nil];
		selectedSortOption = 0;
	}

	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.title = @"hayvan ara";

	self.cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"İptal" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
	[self.cancelItem release];
	self.navigationItem.leftBarButtonItem = self.cancelItem;

	self.searchItem = [[UIBarButtonItem alloc] initWithTitle:@"Ara" style:UIBarButtonItemStyleDone target:self action:@selector(search)];
	[self.searchItem release];
	self.navigationItem.rightBarButtonItem = self.searchItem;

	self.queryField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 25)];
	self.queryField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.queryField.textColor = [UIColor colorWithRed:49/255.0 green:81/255.0 blue:133/255.0 alpha:1.0];
	self.queryField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.queryField.returnKeyType = UIReturnKeyNext;
	self.queryField.delegate = self;
	[self.queryField release];

	self.authorField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 25)];
	self.authorField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.authorField.textColor = [UIColor colorWithRed:49/255.0 green:81/255.0 blue:133/255.0 alpha:1.0];
	self.authorField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.authorField.returnKeyType = UIReturnKeyDone;
	self.authorField.delegate = self;
	[self.authorField release];

	self.guzelSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	[self.guzelSwitch release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section < 2) {
		return 2;
	} else {
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;

	if(indexPath.section == 1) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		if(indexPath.row == 0) {
			cell.textLabel.text = @"sıra şekli";
			cell.detailTextLabel.text = [sortOptions objectAtIndex:selectedSortOption];
		} else {
			cell.textLabel.text = @"şu gün";
			if(self.selectedDate != nil) {
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateStyle:NSDateFormatterLongStyle];
				[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
				cell.detailTextLabel.text = [dateFormatter stringFromDate:self.selectedDate];
				[dateFormatter release];
			}
		}
	} else {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		if(indexPath.section == 0) {
			if(indexPath.row == 0) {
				cell.textLabel.text = @"şey";
				[cell addSubview:queryField];
			} else {
				cell.textLabel.text = @"yazarı";
				[cell addSubview:authorField];
			}
		} else {
			cell.textLabel.text = @"güzelinden olsun";
			cell.accessoryView = guzelSwitch;
		}
	}

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0) {
		if(indexPath.row == 0) {
			[queryField becomeFirstResponder];
		} else {
			[authorField becomeFirstResponder];
		}
	} else if(indexPath.section == 1) {
		if(indexPath.row == 0) {
			OptionController *optionController = [[OptionController alloc] initWithStyle:UITableViewStyleGrouped];
			optionController.title = @"sıra şekli";
			optionController.options = sortOptions;
			optionController.selectedIndex = selectedSortOption;
			optionController.delegate = self;
			[self.navigationController pushViewController:optionController animated:YES];
			[optionController release];
		} else {
			[queryField resignFirstResponder];
			[authorField resignFirstResponder];

			CGRect initialFrame;
			CGRect finalFrame;

			mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
			[delegate lockOrientation:self.interfaceOrientation];

			if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
				initialFrame = CGRectMake(0, 260, 320, 480);
				finalFrame = CGRectMake(0, 0, 320, 480);
			} else {
				initialFrame = CGRectMake(0, 206, 480, 320);
				finalFrame = CGRectMake(0, 0, 480, 320);
			}

			UIView *parentView = [delegate.window.subviews objectAtIndex:0];

			DatePickerView *datePicker = [[DatePickerView alloc] initWithFrame:initialFrame];
			if(self.selectedDate != nil) {
				[datePicker setSelectedDate:selectedDate];
			}
			[datePicker setDelegate:self];
			[parentView addSubview:datePicker];
			[datePicker release];

			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[datePicker setFrame:finalFrame];
			[UIView commitAnimations];
		}
	}
}

#pragma mark -
#pragma mark Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == queryField) {
		[authorField becomeFirstResponder];
	} else {
		[authorField resignFirstResponder];
	}

	return NO;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[cancelItem release];
	[searchItem release];
	[queryField release];
	[authorField release];
	[guzelSwitch release];
	[sortOptions release];

	[super dealloc];
}

- (void)viewDidUnload {
	self.cancelItem = nil;
	self.searchItem = nil;
	self.queryField = nil;
	self.authorField = nil;
	self.guzelSwitch = nil;
}

#pragma mark -

- (void)cancel {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)search {
	EksiLinkController *linkController = [[EksiLinkController alloc] init];
	linkController.URL = [API URLForAdvancedSearchQuery:queryField.text
												 author:authorField.text
										   sortCriteria:selectedSortOption
												   date:selectedDate
												  guzel:guzelSwitch.on];

	if(![queryField.text isEqualToString:@""]) {
		linkController.title = queryField.text;
	} else if(![authorField.text isEqualToString:@""]) {
		linkController.title = authorField.text;
	}

	[self.navigationController pushViewController:linkController animated:YES];
	[linkController release];
}

- (void)pickedOption:(NSUInteger)option {
	selectedSortOption = option;
	[self.tableView reloadData];
}

- (void)datePicker:(DatePickerView *)datePicker pickedDate:(NSDate *)date {
	self.selectedDate = date;
	[self.tableView reloadData];
}

- (void)datePickerCancelled:(DatePickerView *)datePicker {
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
