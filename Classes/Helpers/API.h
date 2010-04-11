//
//  API.h
//  mayhos
//
//  Created by Can Berk Güder on 11/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject {
}

+ (NSURL *)todayURL;
+ (NSURL *)yesterdayURL;

+ (NSURL *)URLForSearchQuery:(NSString *)query;

+ (NSURL *)URLForTitle:(NSString *)title;
+ (NSURL *)URLForTitle:(NSString *)title withSearchQuery:(NSString *)query;

@end
