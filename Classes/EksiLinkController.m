//
//  EksiLinkController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/28/08.
//  Copyright 2008 Chocolate IT Solutions. All rights reserved.
//

#import "EksiLinkController.h"

@implementation EksiLinkController

@synthesize myTableView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self == [super initWithCoder:aDecoder])
	{
		responseData = [[NSMutableData alloc] init];
		stories = [[NSMutableArray alloc] init];
		
		UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
		[activityIndicator startAnimating];
		[activityIndicator sizeToFit];
		
		activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	}
	
	return self;
}

- (void)dealloc {
	[responseData release];
	[myConnection release];
	[stories release];
	[myURL release];
	
	[super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Content" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *link, *title;
	
	NSString *AHREF = @"<a href=\"";
	NSString *GT    = @">"; 
	
	NSString  *content = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1254StringEncoding];
	NSScanner *scanner = [NSScanner scannerWithString:content];
	
	[stories removeAllObjects];
	
	while([scanner isAtEnd] == NO) {
		if([scanner scanUpToString:AHREF intoString:NULL] &&
		   [scanner scanString:AHREF intoString:NULL] &&
		   [scanner scanUpToString:@"\"" intoString:&link] &&
		   [scanner scanUpToString:GT intoString:NULL] &&
		   [scanner scanString:GT intoString:NULL] &&
		   [scanner scanUpToString:@"</a>" intoString:&title])
		{
			link = [link stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
			EksiTitle *item = [[EksiTitle alloc] initWithTitle:title URL:[NSURL URLWithString:link relativeToURL:myURL]];
			[stories addObject:item];
			[item release];
		}
	}
	
	[myTableView reloadData];
}

@end