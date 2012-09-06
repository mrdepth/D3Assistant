//
//  GearView.m
//  D3Assistant
//
//  Created by mr_depth on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "GearView.h"
#import "UIColor+NSNumber.h"
#import "UIImageView+URL.h"

@interface GearView()
@property (nonatomic, strong) UIImageView* itemColorImageView;
@property (nonatomic, strong) UIImageView* itemIconImageView;
@end

@implementation GearView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
	self.itemColorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue.png"]];
	self.itemColorImageView.frame = self.bounds;
	self.itemColorImageView.contentMode = UIViewContentModeScaleToFill;
	self.itemColorImageView.layer.cornerRadius = 4;
	self.itemColorImageView.layer.borderWidth = 1;
	self.itemColorImageView.layer.borderColor = [[UIColor colorWithNumber:@(0x8bc8d4ff)] CGColor];
	self.itemColorImageView.clipsToBounds = YES;

	self.itemIconImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	self.itemIconImageView.contentMode = UIViewContentModeScaleAspectFill;
	[self.itemIconImageView setImageWithContentsOfURL:[NSURL URLWithString:@"http://us.media.blizzard.com/d3/icons/items/large/helm_205_wizard_male.png"]
											completion:nil
										  failureBlock:nil];

	[self addSubview:self.itemColorImageView];
	[self addSubview:self.itemIconImageView];
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
