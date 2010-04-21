//
//  API.h
//  mayhos
//
//  Created by Can Berk Güder on 11/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	SortAlphabetically,
	SortByDate,
	SortRandom,
	SortGudik
} SortCriteria;

@interface API : NSObject {
}

+ (NSURL *)todayURL;
+ (NSURL *)yesterdayURL;
+ (NSURL *)randomURL;

+ (NSURL *)URLForDate:(NSDate *)date;

+ (NSURL *)URLForSearchQuery:(NSString *)query;
+ (NSURL *)URLForAdvancedSearchQuery:(NSString *)query author:(NSString *)author sortCriteria:(SortCriteria)sortCriteria date:(NSDate *)date guzel:(BOOL)guzel;

+ (NSURL *)URLForTitle:(NSString *)title;
+ (NSURL *)URLForTitle:(NSString *)title withSearchQuery:(NSString *)query;

@end
