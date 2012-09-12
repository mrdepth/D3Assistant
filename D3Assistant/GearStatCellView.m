//
//  GearStatCellView.m
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "GearStatCellView.h"

@implementation GearStatCellView
@synthesize statLabel;

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
	CGSize s = [self.statLabel sizeThatFits:CGSizeMake(self.statLabel.frame.size.width, size.height - 1)];
	s.height += 1;
	if (s.height < 20)
		s.height = 20;
	s.width = size.width;
	return s;
}

@end
