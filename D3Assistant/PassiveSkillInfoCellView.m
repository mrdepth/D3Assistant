//
//  PassiveSkillInfoCellView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "PassiveSkillInfoCellView.h"

@implementation PassiveSkillInfoCellView
@synthesize skillImageView;
@synthesize skillDescriptionLabel;
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
	CGRect frame = self.frame;
	frame.size.height = [self.skillDescriptionLabel sizeThatFits:CGSizeMake(self.skillDescriptionLabel.frame.size.width, 512)].height;
	CGFloat extraHeight = self.frame.size.height - CGRectGetMaxY(self.skillDescriptionLabel.frame);
	
	frame.size.height += self.skillDescriptionLabel.frame.origin.y + extraHeight;
	if (frame.size.height > size.height)
		frame.size.height = size.height;
	return frame.size;
}

@end
