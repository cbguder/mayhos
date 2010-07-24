//
//  EntryCell.h
//  mayhos
//
//  Created by Can Berk Güder on 25/7/2010.
//  Copyright (c) 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiEntry.h"

@interface EntryCell : UITableViewCell {
	UILabel *contentLabel;
	UILabel *authorLabel;
}

- (void)setEksiEntry:(EksiEntry *)eksiEntry;

@end
