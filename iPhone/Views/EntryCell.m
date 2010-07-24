//
//  EntryCell.m
//  mayhos
//
//  Created by Can Berk Güder on 25/7/2010.
//  Copyright (c) 2010 Can Berk Güder. All rights reserved.
//

#import "EntryCell.h"

@implementation EntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
		contentLabel.highlightedTextColor = [UIColor whiteColor];
		contentLabel.font = [UIFont systemFontOfSize:14];
		contentLabel.numberOfLines = 3;
		[self.contentView addSubview:contentLabel];
		[contentLabel release];

		authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		authorLabel.highlightedTextColor = [UIColor whiteColor];
		authorLabel.textAlignment = UITextAlignmentRight;
		authorLabel.font = [UIFont systemFontOfSize:14];
		[self.contentView addSubview:authorLabel];
		[authorLabel release];
	}

	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGFloat width = CGRectGetWidth(self.contentView.frame) - 20.0f;
	CGFloat height = CGRectGetHeight(self.contentView.frame);

	contentLabel.frame = CGRectMake(10.0f, 10.0f, width, height - 48.0f);
	authorLabel.frame = CGRectMake(10.0f, height - 28.0f, width, 18.0f);
}

- (void)setEksiEntry:(EksiEntry *)eksiEntry {
	contentLabel.text = eksiEntry.plainTextContent;
	authorLabel.text = [eksiEntry signature];
}

@end
