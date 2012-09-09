//
//  AttributeCellView.m
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "AttributeCellView.h"

@implementation AttributeCellView
@synthesize titleLabel;
@synthesize valueLabel;

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

- (void) layoutSubviews {
	CGRect frame = self.valueLabel.frame;
	CGFloat maxX = CGRectGetMaxX(self.valueLabel.frame);
	frame.size = [self.valueLabel sizeThatFits:CGSizeMake(self.frame.size.width, self.frame.size.height)];
	frame.size.height = self.valueLabel.frame.size.height;
	frame.origin = CGPointMake(maxX - frame.size.width, self.valueLabel.frame.origin.y);
	self.valueLabel.frame = frame;
	
	frame = self.titleLabel.frame;
	frame.size.width = self.valueLabel.frame.origin.x - 5 - frame.origin.x;
	self.titleLabel.frame = frame;
}

@end
