//
//  BlockedController.h
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockedController : UITableViewController {
	NSMutableArray *blocked;
}

@property (nonatomic,retain) NSMutableArray *blocked;

@end
