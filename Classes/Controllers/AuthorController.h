//
//  AuthorController.h
//  mayhos
//
//  Created by Can Berk Güder on 2/5/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorController : UITableViewController {
	NSString *author;
}

@property (nonatomic,copy) NSString *author;

- (id)initWithAuthor:(NSString *)author;

@end
