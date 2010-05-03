//
//  SortOrderController.m
//  mayhos
//
//  Created by Can Berk Güder on 9/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "OptionController.h"

@implementation OptionController

@synthesize options, selectedIndex, delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if ([delegate respondsToSelector:@selector(pickedOption:)]) {
		[delegate pickedOption:selectedIndex];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	if (selectedIndex == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor colorWithRed:49/255.0 green:81/255.0 blue:133/255.0 alpha:1.0];
	}

	cell.textLabel.text = [options objectAtIndex:indexPath.row];

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	UITableViewCell *cell;

	cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.textLabel.textColor = [UIColor darkTextColor];

	selectedIndex = indexPath.row;

	cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	cell.textLabel.textColor = [UIColor colorWithRed:49/255.0 green:81/255.0 blue:133/255.0 alpha:1.0];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[options release];
	[super dealloc];
}

@end
