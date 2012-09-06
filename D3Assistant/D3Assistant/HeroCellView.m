//
//  HeroCellView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 05.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "HeroCellView.h"
#import "UIColor+NSNumber.h"

@implementation HeroCellView
@synthesize avatarImageView;
@synthesize frameImageView;
@synthesize nameLabels;
@synthesize levelLabels;
@synthesize classLabel;
@synthesize paragonLevelLabel;
@synthesize deadLabel;
@synthesize skullImageView;
@synthesize hardcoreLabel;
@synthesize hardcore;

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
	if (selected) {
		self.frameImageView.image = [UIImage imageNamed:hardcore ? @"frameHeroSelectedHC.png" : @"frameHeroSelectedSC.png"];
	}
	else {
		self.frameImageView.image = [UIImage imageNamed:hardcore ? @"frameHeroHC.png" : @"frameHeroSC.png"];
	}
}

- (void) setHardcore:(BOOL)value {
	hardcore = value;
	
	self.frameImageView.image = [UIImage imageNamed:hardcore ? @"frameHeroHC.png" : @"frameHeroSC.png"];
	for (UILabel* label in self.nameLabels)
		label.textColor = [UIColor colorWithNumber:hardcore ? @(HeroHCNameColor) : @(HeroSCNameColor)];
	self.hardcoreLabel.hidden = !hardcore;
}

@end
