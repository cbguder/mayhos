//
//  LeftFrameController.m
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "RootViewController.h"
#import "FavoritedLeftFrameController.h"
#import "RightFrameController.h"
#import "FavoritesController_Pad.h"
#import "HistoryManager.h"

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

@interface RootViewController ()
@property (nonatomic,retain) NSMutableArray *matches;
- (void)filter:(NSString *)query;
- (void)search:(NSString *)query;
@end

@implementation RootViewController

@synthesize matches;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"mayhoş";
	self.clearsSelectionOnViewWillAppear = NO;

	// TODO: Private API
	if([self.searchDisplayController.searchBar respondsToSelector:@selector(setCombinesLandscapeBars:)]) {
		[self.searchDisplayController.searchBar setCombinesLandscapeBars:NO];
	}
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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.searchDisplayController setActive:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		return [matches count];
	}

	return kRowLast;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	if(tableView == self.searchDisplayController.searchResultsTableView) {
		cell.textLabel.text = [matches objectAtIndex:indexPath.row];
		return cell;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return (tableView == self.searchDisplayController.searchResultsTableView);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		[[HistoryManager sharedManager] removeString:[self.matches objectAtIndex:indexPath.row]];
		[self.matches removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		[self search:[matches objectAtIndex:indexPath.row]];
		return;
	}

 	if(indexPath.row == kRowFavorites) {
		FavoritesController_Pad *favoritesController = [[FavoritesController_Pad alloc] init];
		favoritesController.title = @"favorites";
		[self.navigationController pushViewController:favoritesController animated:YES];
		[favoritesController release];
	} else if(indexPath.row == kRowFeatured || indexPath.row == kRowFAQ) {
		EksiTitle *eksiTitle;

		if(indexPath.row == kRowFeatured) {
			eksiTitle = [EksiTitle titleWithURL:[API featuredURL]];
		} else {
			eksiTitle = [EksiTitle titleWithTitle:kFAQTitle];
		}

		UIAppDelegatePad.rightFrameController.eksiTitle = eksiTitle;
	} else {
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
		}

		[self.navigationController pushViewController:leftFrameController animated:YES];
		[leftFrameController release];
	}
}

#pragma mark -
#pragma mark Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self search:searchBar.text];
}

#pragma mark -
#pragma mark Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self filter:searchString];
	return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
	self.matches = nil;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
	self.matches = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[matches release];
	[super dealloc];
}

#pragma mark -
#pragma mark Search

- (void)filter:(NSString *)query {
	if([query isEqualToString:@""]) {
		self.matches = nil;
		return;
	}

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@", [NSString stringWithFormat:@"*%@*", query]];
	self.matches = [NSMutableArray arrayWithArray:[[HistoryManager sharedManager].history allObjects]];
	[matches filterUsingPredicate:predicate];
	[matches sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)search:(NSString *)query {
	[[HistoryManager sharedManager] addString:query];

	if(self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
		[self.searchDisplayController.searchBar resignFirstResponder];
		UIAppDelegatePad.rightFrameController.eksiTitle = [EksiTitle titleWithTitle:query];
	} else {
		FavoritedLeftFrameController *leftFrameController = [[FavoritedLeftFrameController alloc] init];
		leftFrameController.URL = [API URLForSearchQuery:query];
		leftFrameController.title = query;

		[self.navigationController pushViewController:leftFrameController animated:YES];
		[leftFrameController release];
	}
}

@end
