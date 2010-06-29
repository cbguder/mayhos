//
//  ModalPickerView.h
//  mayhos
//
//  Created by Can Berk Güder on 9/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalPickerView : UIView {
	UIToolbar *toolbar;
	CGFloat pickerHeight;
	CGFloat pickerPos;
	CGFloat totalHeight;
}

- (void)easeOutFromSuperview;

@end
