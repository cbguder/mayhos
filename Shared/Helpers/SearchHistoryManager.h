//
//  SearchHistoryManager.h
//  mayhos
//
//  Created by Can Berk Güder on 12/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHistoryManager : NSObject {
	NSMutableSet *history;
}

@property (nonatomic, readonly) NSSet *history;

+ (SearchHistoryManager *)sharedManager;

- (void)addString:(NSString *)string;
- (void)removeString:(NSString *)string;

@end
