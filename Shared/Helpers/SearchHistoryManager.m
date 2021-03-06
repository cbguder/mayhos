//
//  SearchHistoryManager.m
//  mayhos
//
//  Created by Can Berk Güder on 12/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "SearchHistoryManager.h"
#import "SynthesizeSingleton.h"

@implementation SearchHistoryManager

SYNTHESIZE_SINGLETON_FOR_CLASS(SearchHistoryManager, Manager);

@synthesize history;

- (id)init {
	if ((self = [super init])) {
		history = [[NSMutableSet alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"history"]];
	}

	return self;
}

- (void)saveHistory {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[self.history allObjects] forKey:@"history"];
	[defaults synchronize];
}

- (void)addString:(NSString *)string {
	@synchronized(self) {
		[history addObject:string];
		[self saveHistory];
	}
}

- (void)removeString:(NSString *)string {
	@synchronized(self) {
		[history removeObject:string];
		[self saveHistory];
	}
}

@end
