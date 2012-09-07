//
//  SocketView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "SocketView.h"
#import "UIImageView+URL.h"

@interface SocketView()
@property (nonatomic, strong) UIImageView* backgroundImageView;

@end

@implementation SocketView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"socket.png"]];
		self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;

		self.gemImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.gemImageView.contentMode = UIViewContentModeScaleToFill;
		
		[self addSubview:self.backgroundImageView];
		[self addSubview:self.gemImageView];
		self.backgroundImageView.frame = self.bounds;
		
		CGRect frame = self.backgroundImageView.frame;
		frame.origin.x += 4;
		frame.origin.y += 4;
		frame.size.width -= 8;
		frame.size.height -= 8;

		self.gemImageView.frame = frame;
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

@end
