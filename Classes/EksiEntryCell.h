//
//  EksiEntryCell.h
//  Eksi Sozluk
//
//  Created by Can Berk Güder on 29/3/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiEntry.h"

@interface EksiEntryCell : UITableViewCell {
	UIView *contentView;
	EksiEntry *entry;
}

@property (retain) EksiEntry *entry;

- (void)drawContentView:(CGRect)rect;

@end
