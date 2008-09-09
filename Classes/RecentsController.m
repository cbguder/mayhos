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

	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if([stories count] == 0) {
		NSString *url = @"http://sozluk.sourtimes.org/index.asp";
		[self parseXMLFileAtURL:url];
	}
	
	cellSize = CGSizeMake([[self tableView] bounds].size.width, 60);
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void)parseXMLFileAtURL:(NSString *)URL {
	stories = [[NSMutableArray alloc] init];
	
	NSURL *url = [NSURL URLWithString:URL];
	parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
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
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
	
	[[self tableView] reloadData];
}

@end

