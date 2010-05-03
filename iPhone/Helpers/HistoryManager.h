//
//  HistoryManager.h
//  mayhos
//
//  Created by Can Berk Güder on 12/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryManager : NSObject {
	NSMutableSet *history;
}

@property (nonatomic,readonly) NSSet *history;

+ (HistoryManager *)sharedManager;

- (void)addString:(NSString *)string;
- (void)removeString:(NSString *)string;

@end
