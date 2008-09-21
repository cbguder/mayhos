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
	}
	
	// Configure the cell
	int storyIndex = [indexPath indexAtPosition:[indexPath length] - 1];
	[cell setText:[[stories objectAtIndex:storyIndex] objectForKey:@"title"]];
	
	return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
*/
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	}
	if (editingStyle == UITableViewCellEditingStyleInsert) {
	}
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


- (void)dealloc {
	[currentElement release];
	[parser release];
	[stories release];
	[item release];
	[currentTitle release];
	[myURL release];

	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];

	stories = [[NSMutableArray alloc] init];

	UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)] autorelease];
	[activityIndicator startAnimating];

	myURL = [[NSURL alloc] initWithString:@"http://sozluk.sourtimes.org/index.asp"];

	activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh	target:self	action:@selector(refresh)];
	
	self.navigationItem.rightBarButtonItem = activityItem;		
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if([stories count] == 0) {
		[self parseXMLFileAtURL:myURL];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void)refresh {
	[self.navigationItem setRightBarButtonItem:activityItem animated:YES];
	[self parseXMLFileAtURL:myURL];
}

-(void)parseXMLFileAtURL:(NSURL *)URL {
	[stories removeAllObjects];
	
	parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
	
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
	[parser release];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
}

-(void)parser:(NSXMLParser *)parser parseErrorOcurred:(NSError *)parseError {
	NSString *errorString = [NSString stringWithFormat:@"Parse error: %i", [parseError code]];
	NSLog(@"Parse Error: %i", [parseError code]);
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self	cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributes {
	currentElement = [elementName copy];
		
	if([elementName isEqualToString:@"a"]) {
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentLink = [[attributes objectForKey:@"href"] copy];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName {
	if([elementName isEqualToString:@"a"] && [currentLink hasPrefix:@"show.asp"]) {
		[item setObject:currentTitle forKey:@"title"];
		[stories addObject:[item copy]];
	}
	
	currentElement = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if([currentElement isEqualToString:@"a"]) {
		[currentTitle appendString:string];
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
	[self.tableView reloadData];
	[self.navigationItem setRightBarButtonItem:refreshItem animated:YES];	
}

@end

