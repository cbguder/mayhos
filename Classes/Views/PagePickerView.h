//
//  PagePickerView.h
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PagePickerDelegate;

@interface PagePickerView : UIView {
	UIPickerView *pickerView;
	UIToolbar *toolbar;
	CGFloat totalHeight;
	id delegate;
}

@property (nonatomic,assign) id<PagePickerDelegate> delegate;

- (void)setSelectedPage:(NSUInteger)page;

@end

@protocol PagePickerDelegate <UIPickerViewDataSource,UIPickerViewDelegate>
- (void)pagePicked:(NSInteger)page;
@end
