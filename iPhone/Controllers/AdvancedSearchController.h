//
//  AdvancedSearchController.h
//  mayhos
//
//  Created by Can Berk Güder on 22/3/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionController.h"
#import "DatePickerView.h"
#import "SearchController.h"

@interface AdvancedSearchController : UITableViewController <UITextFieldDelegate,OptionControllerDelegate,DatePickerDelegate> {
	UIBarButtonItem *cancelItem;
	UIBarButtonItem *searchItem;

	UITextField *queryField;
	UITextField *authorField;

	UISwitch *guzelSwitch;

	NSArray *sortOptions;
	NSUInteger selectedSortOption;

	NSDate *selectedDate;
}

@property (nonatomic, retain) UIBarButtonItem *cancelItem;
@property (nonatomic, retain) UIBarButtonItem *searchItem;

@property (nonatomic, retain) UITextField *queryField;
@property (nonatomic, retain) UITextField *authorField;

@property (nonatomic, retain) UISwitch *guzelSwitch;

@property (nonatomic, retain) NSArray *sortOptions;
@property (nonatomic, retain) NSDate *selectedDate;

@end
