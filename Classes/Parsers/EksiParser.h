//
//  EksiParser.h
//  mayhos
//
//  Created by Can Berk Güder on 8/1/2010.
//  Copyright 2010 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/HTMLparser.h>

@protocol EksiParserDelegate;

@interface EksiParser : NSObject {
	htmlParserCtxtPtr context;
	xmlNodePtr root;

	NSURLConnection *connection;
	NSURL *baseURL;
	NSURL *URL;

	id delegate;

	NSMutableArray *results;
	NSUInteger pages;
	NSUInteger currentPage;
}

- (id)initWithURL:(NSURL *)URL delegate:(id<EksiParserDelegate>)delegate;
- (void)parseDocument;
- (void)parse;

@property (nonatomic,retain) NSURL *URL;
@property (nonatomic,retain) NSURL *baseURL;
@property (nonatomic,assign) id<EksiParserDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *results;
@property (nonatomic,readonly) NSUInteger pages;
@property (nonatomic,readonly) NSUInteger currentPage;

@end

@protocol EksiParserDelegate
@optional
- (void)parserDidFinishParsing:(EksiParser *)parser;
- (void)parser:(EksiParser *)parser didFailWithError:(NSError *)error;
@end
