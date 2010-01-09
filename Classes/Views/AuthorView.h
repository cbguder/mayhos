//
//  AuthorView.h
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientView.h"

@interface AuthorView : GradientView {
	NSString *author;
	NSString *date;
}

- (void)setAuthor:(NSString *)author;
- (void)setDate:(NSString *)date;

@end
