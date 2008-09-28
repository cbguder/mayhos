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


- (void)dealloc {
	[responseData release];
	[myConnection release];
	[stories release];
	[myURL release];
	
	[super dealloc];
}

- (void)viewDidLoad {
	responseData = [[NSMutableData alloc] init];
	stories = [[NSMutableArray alloc] init];
	
	UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
	[activityIndicator startAnimating];
	[activityIndicator sizeToFit];
	
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
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
	
	cell.text = [[stories objectAtIndex:[indexPath row]] objectForKey:@"title"];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath	animated:YES];
	NSDictionary *story = [stories objectAtIndex:[indexPath row]];
	UIViewController *title = [[TitleController alloc] initWithTitle:[story objectForKey:@"title"] URL:[story objectForKey:@"link"]];
	[self.navigationController pushViewController:title animated:YES];
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
			link = [[NSURL alloc] initWithString:link relativeToURL:myURL];
			NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:link, @"link", title, @"title", nil];
			[stories addObject:item];
		}
	}
	
	[myTableView reloadData];
}

@end