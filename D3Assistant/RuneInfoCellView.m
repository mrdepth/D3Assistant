//
//  RuneInfoCellView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "RuneInfoCellView.h"

@implementation RuneInfoCellView
@synthesize runeImageView;
@synthesize runeNameLabel;
@synthesize runeDescriptionLabel;
@synthesize levelLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGSize) sizeThatFits:(CGSize)size {
	[super layoutSubviews];
	CGRect frame = self.frame;
	frame.size.height = [self.runeDescriptionLabel sizeThatFits:CGSizeMake(self.runeDescriptionLabel.frame.size.width, 512)].height;
	CGFloat extraHeight = self.frame.size.height - CGRectGetMaxY(self.runeDescriptionLabel.frame);
	
	frame.size.height += self.runeDescriptionLabel.frame.origin.y + extraHeight;
	if (frame.size.height > size.height)
		frame.size.height = size.height;
	return frame.size;
}

@end
