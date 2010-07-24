//
//  PagePickerView.h
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalPickerView.h"

@protocol PagePickerDelegate;

@interface PagePickerView : ModalPickerView <UIPickerViewDataSource, UIPickerViewDelegate> {
	UIPickerView *pickerView;

	NSUInteger numberOfPages;
	NSUInteger currentPage;

	id delegate;
}

@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, assign) id<PagePickerDelegate> delegate;

@end

@protocol PagePickerDelegate
- (void)pagePicker:(PagePickerView *)pagePicker pickedPage:(NSUInteger)page;
@end
