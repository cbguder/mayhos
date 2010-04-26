//
//  BlockedManager.m
//  mayhos
//
//  Created by Can Berk Güder on 25/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import "BlockedManager.h"

static BlockedManager *SharedManager = nil;

@implementation BlockedManager

@synthesize blocked;

+ (BlockedManager *)sharedManager {
	@synchronized(self) {
		if(SharedManager == nil) {
			SharedManager = [[self allocWithZone:NULL] init];
		}
	}
	
	return SharedManager;
}

- (id)init {
	if(self = [super init]) {
		blocked = [[NSMutableSet alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"blocked"]];
	}

	return self;
}

- (void)saveHistory {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[self.blocked allObjects] forKey:@"blocked"];
	[defaults synchronize];
}

- (void)addString:(NSString *)string {
	@synchronized(self) {
		[blocked addObject:string];
		[self saveHistory];
	}
}

- (void)removeString:(NSString *)string {
	@synchronized(self) {
		[blocked removeObject:string];
		[self saveHistory];
	}
}

- (BOOL)hasString:(NSString *)string {
	return [blocked containsObject:string];
}

@end
