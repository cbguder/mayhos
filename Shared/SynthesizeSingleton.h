//
//  SynthesizeSingleton.h
//  CBGKit
//
//  Created by Can Berk Güder on 15/7/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, shortname) \
 \
static classname *shared##shortname = nil; \
 \
+ (classname *)shared##shortname { \
	@synchronized(self) { \
		if (shared##shortname == nil) { \
			shared##shortname = [[self alloc] init]; \
		} \
	} \
 \
	return shared##shortname; \
} \
 \
+ (id)allocWithZone:(NSZone *)zone \
{ \
	@synchronized(self) { \
		if (shared##shortname == nil) { \
			shared##shortname = [super allocWithZone:zone]; \
			return shared##shortname; \
		} \
	} \
 \
	return nil; \
} \
 \
- (id)copyWithZone:(NSZone *)zone { \
	return self; \
} \
 \
- (id)retain { \
	return self; \
} \
 \
- (NSUInteger)retainCount { \
	return NSUIntegerMax; \
} \
 \
- (oneway void)release { \
} \
 \
- (id)autorelease { \
	return self; \
}
