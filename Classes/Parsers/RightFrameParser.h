//
//  RightFrameParser.h
//  mayhos
//
//  Created by Can Berk Güder on 8/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EksiParser.h"

@interface RightFrameParser : EksiParser {
	NSMutableString *title;
	BOOL hasMoreToLoad;

	NSMutableString *tempEntry;
	NSMutableString *tempAuthor;
}

@property (nonatomic,readonly) NSString *title;

@end
