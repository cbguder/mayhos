//
//  TitleController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-24.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import "TitleController.h"


@implementation TitleController


- (id)initWithTitle:(NSString *)title URL:(NSURL *)url {
	if (self = [super init]) {
		self.title = title;
		myURL = url;
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [entries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
/*
	static NSString *MyIdentifier = @"EntryCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
*/
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	NSDictionary *entry = [entries objectAtIndex:[indexPath row]];

	UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 300, 20)];
	textView.numberOfLines = 0;
	textView.lineBreakMode = UILineBreakModeWordWrap;
	textView.font = [UIFont systemFontOfSize:14];
	textView.text = [entry objectForKey:@"content"];
	
	CGFloat pos = [self tableView:tableView heightForRowAtIndexPath:indexPath] - 24;
	UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(10, pos, 300, 20)];
	author.numberOfLines = 1;
	author.textAlignment = UITextAlignmentRight;
	author.font = [UIFont systemFontOfSize:14];
	author.text = [NSString stringWithFormat:@"%@, %@", [entry objectForKey:@"author"], [entry objectForKey:@"date"]];

	[cell.contentView addSubview:textView];
	[cell.contentView addSubview:author];
	[textView sizeToFit];
	[textView release];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = [[[entries objectAtIndex:[indexPath row]] objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:14]
																				     constrainedToSize:CGSizeMake(300, 4000)
																					 lineBreakMode:UILineBreakModeWordWrap];
	return size.height + 15 + 33;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)dealloc {
	[responseData release];
	[connection release];
	[entries release];
	[myURL release];

	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];

	entries = [[NSMutableArray alloc] init];

	UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
	[activityIndicator startAnimating];
	[activityIndicator sizeToFit];

	responseData = [[NSMutableData data] retain];
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	tumuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(tumunu_goster)];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([entries count] == 0) {
		[self.navigationItem setRightBarButtonItem:activityItem animated:YES];
		NSURLRequest *request =	[NSURLRequest requestWithURL:myURL];
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Content" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
	[errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *entry, *author, *date;
	NSUInteger lastPosition;
	
	NSString *LI     = @"<li ";
	NSString *GT     = @">";
	NSString *DIV    = @"<div class=\"aul\">";
	NSString *ENDA   = @"</a>";
	NSString *BUTTON = @"<button ";
	
	NSString  *content = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1254StringEncoding];
	NSScanner *scanner = [NSScanner scannerWithString:content];
	
	NSString *theXSLTString = @"<?xml version='1.0' encoding='utf-8'?> \
	<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:xhtml='http://www.w3.org/1999/xhtml'> \
	<xsl:output method='text'/> \
	<xsl:template match='xhtml:br'><xsl:text>\n</xsl:text></xsl:template> \
	<xsl:template match='xhtml:a'><xsl:value-of select='.'/></xsl:template> \
	</xsl:stylesheet>";
	
	tumu_link = nil;
	[entries removeAllObjects];
	
	while([scanner isAtEnd] == NO) {
		if([scanner scanUpToString:LI intoString:NULL] &&
		   [scanner scanUpToString:GT intoString:NULL] &&
		   [scanner scanString:GT intoString:NULL] &&
		   [scanner scanUpToString:DIV intoString:&entry] &&
		   [scanner scanString:DIV intoString:NULL] &&
		   [scanner scanUpToString:GT intoString:NULL] &&
		   [scanner scanString:GT intoString:NULL] &&
		   [scanner scanUpToString:ENDA intoString:&author] &&
		   [scanner scanString:ENDA intoString:NULL] &&
		   [scanner scanString:@", " intoString:NULL] &&
		   [scanner scanUpToString:@")" intoString:&date])
		{
			lastPosition = [scanner scanLocation];
			
			NSXMLDocument *theDocument = [[[NSXMLDocument alloc] initWithXMLString:entry options:NSXMLDocumentTidyHTML error:NULL] autorelease];
			NSData *theData = [theDocument objectByApplyingXSLTString:theXSLTString arguments:NULL error:NULL];
			entry = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];

			NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:entry, @"content", author, @"author", date, @"date", nil];
			[entries addObject:item];
		} else {
			[scanner setScanLocation:lastPosition];
			if([scanner scanUpToString:BUTTON intoString:NULL] &&
			   [scanner scanUpToString:@"'" intoString:NULL] &&
			   [scanner scanString:@"'" intoString:NULL] &&
			   [scanner scanUpToString:@"'" intoString:&tumu_link])
			{
				tumu_link = [[tumu_link stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] retain];
				break;
			}
		}
	}

	if(tumu_link == nil) {
		[self.navigationItem setRightBarButtonItem:NULL animated:YES];
	} else {
		[self.navigationItem setRightBarButtonItem:tumuItem animated:YES];
	}
	
	[self.tableView reloadData];
}

- (void)tumunu_goster {
	[self.navigationItem setRightBarButtonItem:activityItem animated:YES];

	myURL = [[NSURL alloc] initWithString:tumu_link relativeToURL:myURL];
	NSURLRequest *request =	[NSURLRequest requestWithURL:myURL];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end

