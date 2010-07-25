//
//  EksiEntry.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 29/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EksiEntry : NSObject {
	NSUInteger order;

	NSString *author;
	NSString *content;
	NSString *plainTextContent;

	NSDate *date;
	NSDate *lastEdit;
}

@property (nonatomic, assign) NSUInteger order;

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *plainTextContent;

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *lastEdit;

+ (NSDate *)parseDate:(NSString *)theDate;
+ (NSDate *)parseDate:(NSString *)theDate withBaseDate:(NSString *)theBaseDate;

- (void)setAuthorAndDateFromSignature:(NSString *)signature;

- (NSString *)dateString;
- (NSString *)signature;

@end
