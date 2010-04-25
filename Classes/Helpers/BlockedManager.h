//
//  BlockedManager.h
//  mayhos
//
//  Created by Can Berk Güder on 25/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockedManager : NSObject {
	NSMutableSet *blocked;
}

@property (nonatomic,readonly) NSSet *blocked;

+ (BlockedManager *)sharedManager;

@end
