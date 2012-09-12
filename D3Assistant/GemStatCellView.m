//
//  GemStatCellView.m
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "GemStatCellView.h"

@implementation GemStatCellView
@synthesize gemImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGSize) sizeThatFits:(CGSize)size {
	CGSize s = [self.statLabel sizeThatFits:CGSizeMake(self.statLabel.frame.size.width, size.height - 1)];
	s.height += 1;
	if (s.height < 30)
		s.height = 30;
	s.width = size.width;
	return s;
}

@end
