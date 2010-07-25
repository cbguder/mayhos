//
//  PagePickerController.h
//  mayhos
//
//  Created by Can Berk Güder on 31/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PagePickerControllerDelegate;

@interface PagePickerController : UIViewController {
	UISlider *slider;
	UILabel *label;

	NSUInteger currentPage;
	NSUInteger totalPages;

	id delegate;
}

@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalPages;

@property (nonatomic, assign) id<PagePickerControllerDelegate> delegate;

- (id)initWithDelegate:(id)delegate;

@end

@protocol PagePickerControllerDelegate
- (void)pagePickerController:(PagePickerController *)pagePickerController pickedPage:(NSUInteger)page;
@end
