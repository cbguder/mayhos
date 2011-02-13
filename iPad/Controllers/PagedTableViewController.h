//
//  PagedTableViewController.h
//  mayhos
//
//  Created by Can Berk Güder on 6/6/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedViewController.h"

@interface PagedTableViewController : PagedViewController <UITableViewDataSource, UITableViewDelegate> {
	BOOL clearsSelectionOnViewWillAppear;
	UITableViewStyle tableViewStyle;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;

- (id)initWithStyle:(UITableViewStyle)style;

@end
