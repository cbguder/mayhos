//
//  EntryController.h
//  mayhos
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiTitle.h"
#import "AuthorView.h"

@interface EntryController : UIViewController <UIWebViewDelegate> {
	EksiTitle *eksiTitle;
	NSUInteger index;

	AuthorView *authorView;
	UIWebView *contentView;
	UISegmentedControl *upDownControl;
}

@property (nonatomic,retain) IBOutlet AuthorView *authorView;
@property (nonatomic,retain) IBOutlet UIWebView *contentView;

- (id)initWithEksiTitle:(EksiTitle *)title index:(NSUInteger)index;

@end
