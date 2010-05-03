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

@interface PagePickerView : ModalPickerView {
	UIPickerView *pickerView;
	id delegate;
}

@property (nonatomic,assign) id<PagePickerDelegate> delegate;

- (void)setSelectedPage:(NSUInteger)page;

@end

@protocol PagePickerDelegate <UIPickerViewDataSource,UIPickerViewDelegate>
- (void)pagePicker:(PagePickerView *)pagePicker pickedPage:(NSInteger)page;
@end
