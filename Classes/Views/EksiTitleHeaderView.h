//
//  EksiTitleHeaderView.h
//  mayhos
//
//  Created by Can Berk Güder on 28/3/2009.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientView.h"

@interface EksiTitleHeaderView : GradientView {
	NSString *text;
}

@property (nonatomic,copy) NSString *text;

@end
