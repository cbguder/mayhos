//
//  EksiEntry.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EksiEntry : NSObject {
	NSString *author;
	NSString *content;
	NSDate *date;
	NSDate *lastEdit;
}

- (id)initWithAuthor:(NSString *)author content:(NSString *)content date:(NSDate *)date lastEdit:(NSDate *)lastEdit;
- (NSString *)dateString;
- (NSString *)signature;
+ (NSDate *)parseDate:(NSString *)theDate;
+ (NSDate *)parseDate:(NSString *)theDate withBaseDate:(NSString *)theBaseDate;

@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,retain) NSDate *date;
@property (nonatomic,retain) NSDate *lastEdit;

@end
