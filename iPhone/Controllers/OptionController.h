//
//  SortOrderController.h
//  mayhos
//
//  Created by Can Berk Güder on 9/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionControllerDelegate;

@interface OptionController : UITableViewController {
	NSArray *options;
	NSUInteger selectedIndex;
	id delegate;
}

@property (nonatomic, retain) NSArray *options;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) id<OptionControllerDelegate> delegate;

@end

@protocol OptionControllerDelegate
- (void)pickedOption:(NSUInteger)option;
@end
