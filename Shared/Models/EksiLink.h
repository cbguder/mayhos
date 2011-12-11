//
//  EksiLink.h
//  mayhos
//
//  Created by Can Berk Güder on 15/4/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EksiLink : NSObject {
	NSString *title;
	NSURL *URL;
	NSInteger entryCount;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSURL *URL;
@property (nonatomic) NSInteger entryCount;

+ (id)linkWithTitle:(NSString *)title URL:(NSURL *)URL;

- (id)initWithTitle:(NSString *)theTitle URL:(NSURL *)theURL;

@end
