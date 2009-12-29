//
//  EntryController.h
//  Eksi Sozluk
//
//  Created by Can Berk Güder on 19/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EksiEntry.h"

@interface EntryController : UIViewController {
	EksiEntry *entry;
}

@property (nonatomic,retain) EksiEntry *entry;

- (id)initWithEntry:(EksiEntry *)entry;

@end
