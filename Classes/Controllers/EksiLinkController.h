//
//  EksiLinkController.h
//  EksiSozluk
//
//  Created by Can Berk Güder on 28/9/2008.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritedController.h"
#import "EksiParser.h"

@interface EksiLinkController : FavoritedController <EksiParserDelegate> {
	NSArray *links;
	NSURL *URL;

	BOOL noToolbar;
}

@property (nonatomic,retain) NSArray *links;
@property (nonatomic,retain) NSURL *URL;

@property (nonatomic,assign) BOOL noToolbar;

- (void)loadURL;

@end
