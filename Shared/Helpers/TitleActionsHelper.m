//
//  TitleActionsHelper.m
//  mayhos
//
//  Created by Can Berk Güder on 27/1/2012.
//  Copyright (c) 2012 Can Berk Güder. All rights reserved.
//

#import <Twitter/Twitter.h>
#import "TitleActionsHelper.h"
#import "SynthesizeSingleton.h"

@implementation TitleActionsHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(TitleActionsHelper, Helper);

- (UIActionSheet *)actionSheet {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];

	[actionSheet addButtonWithTitle:@"Safari'de Aç"];
	[actionSheet addButtonWithTitle:@"Adresi Kopyala"];

	NSInteger numberOfButtons = 2;

	if ([MFMailComposeViewController canSendMail]) {
		[actionSheet addButtonWithTitle:@"Email"];
		numberOfButtons++;
	}

	Class tweetComposeViewControllerClass = NSClassFromString(@"TWTweetComposeViewController");
	if (tweetComposeViewControllerClass != nil) {
		[actionSheet addButtonWithTitle:@"Tweet"];
		numberOfButtons++;
	}

	[actionSheet addButtonWithTitle:@"Vazgeç"];
	[actionSheet setCancelButtonIndex:numberOfButtons];

	return [actionSheet autorelease];
}

- (void)showActionSheetForViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)barButtonItem {
	parentViewController = viewController;
	[[self actionSheet] showFromBarButtonItem:barButtonItem animated:YES];
}

- (void)showActionSheetForViewController:(UIViewController *)viewController fromToolbar:(UIToolbar *)toolbar {
	parentViewController = viewController;
	[[self actionSheet] showFromToolbar:toolbar];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) return;

	if (![parentViewController respondsToSelector:@selector(eksiTitle)]) return;
	EksiTitle *eksiTitle = [parentViewController performSelector:@selector(eksiTitle)];

	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:eksiTitle.URL];
	} else if (buttonIndex == 1) {
		[[UIPasteboard generalPasteboard] setString:[eksiTitle.URL absoluteString]];
	} else if (buttonIndex == 2) {
		MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
		[mailComposeViewController setMailComposeDelegate:self];
		[mailComposeViewController setSubject:eksiTitle.title];
		[mailComposeViewController setMessageBody:[eksiTitle.URL absoluteString] isHTML:NO];
		[parentViewController presentModalViewController:mailComposeViewController animated:YES];
		[mailComposeViewController release];
	} else if (buttonIndex == 3) {
		TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
		[tweetComposeViewController setInitialText:eksiTitle.title];
		[tweetComposeViewController addURL:eksiTitle.URL];
		[parentViewController presentModalViewController:tweetComposeViewController animated:YES];
		[tweetComposeViewController release];
	}
}

#pragma mark - Mail compose view controller delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
}

@end
