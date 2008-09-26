//
//  TitleController.m
//  EksiSozluk
//
//  Created by Can Berk Güder on 9/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TitleController.h"


@implementation TitleController


- (id)initWithTitle:(NSString *)title {
	if (self = [super init]) {
		self.title = title;
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
	static NSString *MyIdentifier = @"EntryCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
	textView.numberOfLines = 0;
	textView.text = [[[entries objectAtIndex:[indexPath row]] objectForKey:@"content"]
					 stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];

	[cell.contentView addSubview:textView];
	[textView sizeToFit];
	[textView release];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath row] > [entries count] - 1) {
		return 40.0;
	} else {		
		UILabel *textView = [[UILabel alloc] initWithFrame:CGRectZero];
		textView.numberOfLines = 0;
		textView.text = [[[entries objectAtIndex:[indexPath row]] objectForKey:@"content"]
						 stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];

		CGSize size = [textView sizeThatFits:CGSizeMake(300, 40)];
		[textView release];

		return size.height + 15;
	}
}

- (void)dealloc {
	[myURL release];
	[entries release];
	[responseData release];

	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];

	entries = [[NSMutableArray alloc] init];

	UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
	[activityIndicator startAnimating];
	[activityIndicator sizeToFit];

	myURL = [[NSURL URLWithString:[NSString stringWithFormat:@"http://sozluk.sourtimes.org/show.asp?t=%@", 
								  [self.title stringByReplacingOccurrencesOfString:@" " withString:@"+"]]] retain];
	responseData = [[NSMutableData data] retain];

	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if([entries count] == 0) {
		[self.navigationItem setRightBarButtonItem:activityItem animated:YES];
		NSURLRequest *request =	[NSURLRequest requestWithURL:myURL];
		[[NSURLConnection alloc] initWithRequest:request delegate:self];		
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
	NSLog(@"Response");
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"Data: %d", [data length]);
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Content" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
	[errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"Finish: %d", [responseData length]);

	NSString *entry;
	
	NSString *LI  = @"<li ";
	NSString *GT  = @">";
	NSString *DIV = @"<div class=\"aul\">";
	
	NSString  *content = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1254StringEncoding];
	NSScanner *scanner = [NSScanner scannerWithString:content];
	
	while([scanner isAtEnd] == NO) {
		if([scanner scanUpToString:LI intoString:NULL] &&
		   [scanner scanUpToString:GT intoString:NULL] &&
		   [scanner scanString:GT intoString:NULL] &&
		   [scanner scanUpToString:DIV intoString:&entry])
		{
			NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:entry, @"content", nil];
			[entries addObject:item];
		}
	}
	
	NSLog(@"Entries: %d", [entries count]);
	
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
	[self.tableView reloadData];
}


@end

