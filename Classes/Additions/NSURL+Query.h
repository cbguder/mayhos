//
//  NSURL+Query.h
//  mayhos
//
//  Created by Can Berk Güder on 20/4/2009.
//  Copyright 2009 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Query)

- (NSMutableDictionary *)queryDictionary;
- (NSURL *)URLBySettingQueryDictionary:(NSDictionary *)dictionary;
- (NSURL *)normalizedURL;

@end
