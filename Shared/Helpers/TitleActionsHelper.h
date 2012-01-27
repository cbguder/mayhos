//
//  TitleActionsHelper.h
//  mayhos
//
//  Created by Can Berk Güder on 27/1/2012.
//  Copyright (c) 2012 Can Berk Güder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface TitleActionsHelper : NSObject <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	UIViewController *parentViewController;
}

+ (TitleActionsHelper *)sharedHelper;

- (void)showActionSheetForViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)showActionSheetForViewController:(UIViewController *)viewController fromToolbar:(UIToolbar *)toolbar;

@end
