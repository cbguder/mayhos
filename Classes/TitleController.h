//
//  TitleController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiTitle.h"
#import "EksiEntry.h"

@interface TitleController : UITableViewController {
	EksiTitle *eksiTitle;
	NSURL *myURL;
}

- (id)initWithTitle:(EksiTitle *)theTitle;
- (void)setEksiTitle:(EksiTitle *)theTitle;

@property (retain) EksiTitle *eksiTitle;

@end
