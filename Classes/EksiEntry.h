//
//  EksiEntry.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/29/08.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EksiEntry : NSObject {
	NSString *author;
	NSString *content;
	NSDate *date;
	NSDate *lastEdit;
}

- (id)initWithAuthor:(NSString *)theAuthor content:(NSString *)theContent date:(NSDate *)theDate lastEdit:(NSDate *)theLastEdit;
- (NSString *)dateString;
+ (NSDate *)parseDate:(NSString *)theDate;
+ (NSDate *)parseDate:(NSString *)theDate withBaseDate:(NSString *)theBaseDate;


@property (retain) NSString *author;
@property (retain) NSString *content;
@property (retain) NSDate *date;
@property (retain) NSDate *lastEdit;

@end
