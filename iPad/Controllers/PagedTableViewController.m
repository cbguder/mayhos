//
//  PagedTableViewController.m
//  mayhos
//
//  Created by Can Berk Güder on 6/6/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "PagedTableViewController.h"

@implementation PagedTableViewController

@dynamic tableView;
@synthesize clearsSelectionOnViewWillAppear;

#pragma mark -
#pragma mark Initialization

- (id)init {
	return [self initWithStyle:UITableViewStylePlain];
}

- (id)initWithStyle:(UITableViewStyle)style {
	if ((self = [super init])) {
		self.clearsSelectionOnViewWillAppear = YES;
		tableViewStyle = style;
	}

	return self;
}

#pragma mark -
#pragma mark Accessors

- (UITableView *)tableView {
	return (UITableView *)self.view;
}

- (void)setTableView:(UITableView *)aTableView {
	self.view = aTableView;
	[aTableView setDelegate:self];
	[aTableView setDataSource:self];
}

- (void)setEditing:(BOOL)editing {
	[super setEditing:editing];
	[self.tableView setEditing:editing];
}

#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
	self.tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:tableViewStyle] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if ([self.tableView numberOfRowsInSection:0] == 0) {
		[self.tableView reloadData];
	} else if (self.clearsSelectionOnViewWillAppear) {
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView flashScrollIndicators];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

@end
