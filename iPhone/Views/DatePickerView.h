//
//  DatePickerView.h
//  mayhos
//
//  Created by Can Berk Güder on 9/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalPickerView.h"

@protocol DatePickerDelegate;

@interface DatePickerView : ModalPickerView {
	UIDatePicker *datePicker;
	id delegate;
}

@property (nonatomic,assign) id<DatePickerDelegate> delegate;

- (void)setSelectedDate:(NSDate *)date;

@end

@protocol DatePickerDelegate
- (void)datePicker:(DatePickerView *)datePicker pickedDate:(NSDate *)date;
- (void)datePickerCancelled:(DatePickerView *)datePicker;
@end