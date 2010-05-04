//
//  LeftFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RootViewController.h"
#import "LeftFrameController.h"

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"mayhoş";
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	if(indexPath.row == 0) {
		cell.textLabel.text = @"bugün";
	} else if(indexPath.row == 1) {
		cell.textLabel.text = @"dün";
	} else if(indexPath.row == 2) {
		cell.textLabel.text = @"bir gün";
	}

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LeftFrameController *leftFrameController = [[LeftFrameController alloc] initWithStyle:UITableViewStylePlain];

	if(indexPath.row == 0) {
		leftFrameController.title = @"bugün";
		leftFrameController.URL = [API todayURL];
	} else if(indexPath.row == 1) {
		leftFrameController.title = @"dün";
		leftFrameController.URL = [API yesterdayURL];
	} else if(indexPath.row == 2) {
		leftFrameController.title = @"bir gün";
		NSDate *date = randomDate();
		leftFrameController.title = formatDate(date);
		leftFrameController.URL = [API URLForDate:date];
	}

	[self.navigationController pushViewController:leftFrameController animated:YES];
	[leftFrameController release];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
}

- (void)dealloc {
	[super dealloc];
}

@end

