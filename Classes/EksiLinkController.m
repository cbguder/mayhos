//
//  EksiLinkController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/28/08.
//  Copyright 2008 Can Berk Güder. All rights reserved.
//

#import "EksiLinkController.h"

@implementation EksiLinkController

@synthesize myTableView, myURL, myConnection;

#pragma mark Initialization Methods

- (void)viewDidLoad {
	stories = [[NSMutableArray alloc] init];

	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	[activityIndicatorView startAnimating];
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	[activityIndicatorView release];
}

- (void)dealloc {
	[myConnection release];
	[activityItem release];
	[stories release];
	[myURL release];

	[super dealloc];
}

#pragma mark Other Methods

- (void)loadURL {
	if(myConnection != nil) {
        [myConnection cancel];
        self.myConnection = nil;
    }

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self.navigationItem setRightBarButtonItem:activityItem];
	NSURLRequest *request =	[NSURLRequest requestWithURL:myURL
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval:60];
	self.myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectionFinished {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self.navigationItem setRightBarButtonItem:nil];
	self.myConnection = nil;
}

#pragma mark UITableViewController Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *linkCellIdentifier = @"linkCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:linkCellIdentifier];

	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:linkCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	cell.text = [[stories objectAtIndex:[indexPath row]] title];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath	animated:YES];

	UIViewController *title = [[TitleController alloc] initWithTitle:[stories objectAtIndex:[indexPath row]]];
	[self.navigationController pushViewController:title animated:YES];
	[title release];
}

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self connectionFinished];

	NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Content"
														  message:errorMessage
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
	[errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self connectionFinished];

	[stories removeAllObjects];

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
	[parser setDelegate:self];
	[parser parse];
	[parser release];

	[responseData release];
	[myTableView reloadData];
}

#pragma mark NSXMLParserDelegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if([elementName isEqualToString:@"a"]) {
		NSString *link = [attributeDict objectForKey:@"href"];

		if([link hasPrefix:@"show.asp"]) {
			tempTitle = [[EksiTitle alloc] init];
			tempString = [[NSMutableString alloc] init];
			[tempTitle setURL:[NSURL URLWithString:link relativeToURL:myURL]];
			inLink = YES;
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(inLink)
		[tempString appendFormat:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(inLink && [elementName isEqualToString:@"a"]) {
		[tempTitle setTitle:tempString];
		[stories addObject:tempTitle];
		[tempString release];
		[tempTitle release];
		inLink = NO;
	}
}

@end
