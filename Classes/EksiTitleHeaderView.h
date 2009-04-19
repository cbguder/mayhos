//
//  EksiTitleHeaderView.h
//  Eksi Sozluk
//
//  Created by Can Berk Güder on 28/3/2009.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientView.h"

@interface EksiTitleHeaderView : GradientView {
	NSString *text;
}

- (void)setText:(NSString *)text;

@end
