//
//  LeftFrameController.h
//  mayhos
//
//  Created by Can Berk Güder on 4/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
	NSMutableArray *matches;
}

@end
