//
//  MoreController.m
//  mayhos
//
//  Created by Can Berk Güder on 29/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "MoreController.h"
#import "EksiLinkController.h"
#import "TitleController.h"

enum {
	kRowFeatured,
	kRowYesterday,
	kRowRandomDate,
	kRowLastYear,
	kRowRandom,
	kRowFAQ
};

@implementation MoreController

#pragma mark -
#pragma mark View lifecycle

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

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *favoriteCellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:favoriteCellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:favoriteCellIdentifier] autorelease];
	}

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	if(indexPath.row == kRowFeatured) {
		cell.textLabel.text = @"şükela";
	} else if(indexPath.row == kRowYesterday) {
		cell.textLabel.text = @"dün";
	} else if(indexPath.row == kRowRandomDate) {
		cell.textLabel.text = @"bir gün";
	} else if(indexPath.row == kRowRandom) {
		cell.textLabel.text = @"rastgele";
	} else if(indexPath.row == kRowFAQ) {
		cell.textLabel.text = @"asl?";
	} else if(indexPath.row == kRowLastYear) {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *dateComponents = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
		[gregorian release];

		cell.textLabel.text = [NSString stringWithFormat:@"%d", dateComponents.year - 1];
	}

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *viewController;

	if(indexPath.row == kRowFeatured) {
		EksiTitle *eksiTitle = [EksiTitle titleWithTitle:@"" URL:[API featuredURL]];
		viewController = [[TitleController alloc] initWithEksiTitle:eksiTitle];
	} else if(indexPath.row == kRowYesterday) {
		EksiLinkController *eksiLinkController = [[EksiLinkController alloc] init];
		eksiLinkController.title = @"dün";
		eksiLinkController.URL = [API yesterdayURL];
		eksiLinkController.noToolbar = YES;
		viewController = eksiLinkController;
	} else if(indexPath.row == kRowRandomDate || indexPath.row == kRowLastYear) {
		NSDate *date;

		if(indexPath.row == kRowRandomDate) {
			date = randomDate();
		} else {
			date = lastYear();
		}

		EksiLinkController *eksiLinkController = [[EksiLinkController alloc] init];

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterLongStyle];
		eksiLinkController.title = [[dateFormatter stringFromDate:date] lowercaseString];
		eksiLinkController.title = [dateFormatter stringFromDate:date];
		[dateFormatter release];

		eksiLinkController.URL = [API URLForDate:date];
		eksiLinkController.noToolbar = YES;
		viewController = eksiLinkController;
	} else if(indexPath.row == kRowRandom) {
		EksiLinkController *eksiLinkController = [[EksiLinkController alloc] init];
		eksiLinkController.title = @"rastgele";
		eksiLinkController.URL = [API randomURL];
		eksiLinkController.noToolbar = YES;
		viewController = eksiLinkController;
	} else if(indexPath.row == kRowFAQ) {
		NSString *faqTitle = @"sözlük hakkında en çok sorulan sorular";
		EksiTitle *eksiTitle = [EksiTitle titleWithTitle:faqTitle URL:[API URLForTitle:faqTitle]];
		TitleController *titleController = [[TitleController alloc] initWithEksiTitle:eksiTitle];
		titleController.noToolbar = YES;

		viewController = titleController;
	}

	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

@end
