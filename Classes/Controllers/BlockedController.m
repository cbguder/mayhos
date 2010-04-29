//
//  BlockedController.m
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "BlockedController.h"
#import "BlockedManager.h"

@implementation BlockedController

@synthesize blocked;

- (void)loadBlocked {
	self.blocked = [NSMutableArray arrayWithArray:[[[BlockedManager sharedManager] blocked] allObjects]];
	[self.blocked sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	[self loadBlocked];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadBlocked];
	[self.tableView reloadData];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	mayhosAppDelegate *delegate = (mayhosAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.blocked count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = [self.blocked objectAtIndex:indexPath.row];

	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		NSString *author = [self.blocked objectAtIndex:indexPath.row];
		[[BlockedManager sharedManager] removeString:author];
		[self.blocked removeObjectAtIndex:indexPath.row];

		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[blocked release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.blocked = nil;
}

@end
