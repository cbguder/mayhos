//
//  LeftFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RootViewController.h"
#import "LeftFrameController.h"
#import "RightFrameController.h"
#import "FavoritesController_Pad.h"

enum {
	kRowToday,
	kRowYesterday,
	kRowRandomDate,
	kRowLastYear,
	kRowFavorites,
	kRowRandom,
	kRowFeatured,
	kRowFAQ,
	kRowLast
};

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"mayhoş";
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	if(selectedIndexPath) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];

		if(cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
			[self.tableView deselectRowAtIndexPath:selectedIndexPath animated:animated];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return kRowLast;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	if(indexPath.row == kRowFeatured || indexPath.row == kRowFAQ) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	if(indexPath.row == kRowToday) {
		cell.textLabel.text = @"bugün";
	} else if(indexPath.row == kRowYesterday) {
		cell.textLabel.text = @"dün";
	} else if(indexPath.row == kRowRandomDate) {
		cell.textLabel.text = @"bir gün";
	} else if(indexPath.row == kRowLastYear) {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *dateComponents = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
		[gregorian release];

		cell.textLabel.text = [NSString stringWithFormat:@"%d", dateComponents.year - 1];
	} else if(indexPath.row == kRowRandom) {
		cell.textLabel.text = @"rastgele";
	} else if(indexPath.row == kRowFeatured) {
		cell.textLabel.text = @"şükela";
	} else if(indexPath.row == kRowFAQ) {
		cell.textLabel.text = @"asl?";
	} else if(indexPath.row == kRowFavorites) {
		cell.textLabel.text = @"favorites";
	}

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 	if(indexPath.row == kRowFavorites) {
		FavoritesController_Pad *favoritesController = [[FavoritesController_Pad alloc] init];
		favoritesController.title = @"favorites";
		[self.navigationController pushViewController:favoritesController animated:YES];
		[favoritesController release];

		return;
	}

	LeftFrameController *leftFrameController = [[LeftFrameController alloc] initWithStyle:UITableViewStylePlain];

	if(indexPath.row == kRowToday) {
		leftFrameController.title = @"bugün";
		leftFrameController.URL = [API todayURL];
	} else if(indexPath.row == kRowYesterday) {
		leftFrameController.title = @"dün";
		leftFrameController.URL = [API yesterdayURL];
	} else if(indexPath.row == kRowRandomDate || indexPath.row == kRowLastYear) {
		NSDate *date;

		if(indexPath.row == kRowRandomDate) {
			date = randomDate();
		} else {
			date = lastYear();
		}

		leftFrameController.title = formatDate(date);
		leftFrameController.URL = [API URLForDate:date];
	} else if(indexPath.row == kRowRandom) {
		leftFrameController.title = @"rastgele";
		leftFrameController.URL = [API randomURL];
	} else if(indexPath.row == kRowFeatured || indexPath.row == kRowFAQ) {
		EksiTitle *eksiTitle;

		if(indexPath.row == kRowFeatured) {
			eksiTitle = [EksiTitle titleWithTitle:@"" URL:[API featuredURL]];
		} else {
			NSString *faqTitle = @"sözlük hakkında en çok sorulan sorular";
			eksiTitle = [EksiTitle titleWithTitle:faqTitle URL:[API URLForTitle:faqTitle]];
		}

		UINavigationController *navController = [self.splitViewController.viewControllers objectAtIndex:1];
		RightFrameController *rightFrameController = (RightFrameController *)navController.topViewController;
		rightFrameController.eksiTitle = eksiTitle;
		[leftFrameController release];
		return;
	}

	[self.navigationController pushViewController:leftFrameController animated:YES];
	[leftFrameController release];
}

@end
