//
//  RecentsController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 2008-09-09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RecentsController.h"


@implementation RecentsController


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
	}

	return self;
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
	[tableView deselectRowAtIndexPath:indexPath	animated:NO];
	UIViewController *asd = [[TitleController alloc] initWithTitle:[[stories objectAtIndex:[indexPath row]] objectForKey:@"title"]];
/*
	UIViewController *asd = [[UIViewController alloc] init];
	UIWebView *bsd = [[UIWebView alloc] init];
	asd.view = bsd;
	[bsd loadHTMLString:@"<ol><li>asd</li><li>asdasdasd</li></ol>" baseURL:[NSURL URLWithString:@""]];
*/
	[[self navigationController] pushViewController:asd animated:YES];
}

- (void)dealloc {
	[responseData release];
	[stories release];
	[myURL release];

	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];

	stories = [[NSMutableArray alloc] init];

	UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
	[activityIndicator startAnimating];
	[activityIndicator sizeToFit];

	myURL = [[NSURL URLWithString:@"http://sozluk.sourtimes.org/index.asp"] retain];
	responseData = [[NSMutableData data] retain];

	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh	target:self	action:@selector(refresh)];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if([stories count] == 0) {
		[self refresh];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) refresh {
	[self.navigationItem setRightBarButtonItem:activityItem animated:YES];
	NSURLRequest *request =	[NSURLRequest requestWithURL:myURL];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
	[self.navigationItem setRightBarButtonItem:refreshItem animated:YES];
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
		   [scanner scanUpToString:@"\" " intoString:&link] &&
		   [scanner scanUpToString:GT intoString:NULL] &&
		   [scanner scanString:GT intoString:NULL] &&
		   [scanner scanUpToString:@"</a>" intoString:&title])
		{
			NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:link, @"link", title, @"title", nil];
			[stories addObject:item];
		}
	}
	
	[self.navigationItem setRightBarButtonItem:refreshItem animated:YES];
	[self.tableView reloadData];
}


@end

