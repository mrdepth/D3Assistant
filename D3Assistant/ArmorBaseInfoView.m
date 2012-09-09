//
//  ArmorBaseInfoView.m
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ArmorBaseInfoView.h"
#import "D3APISession.h"
#import "UIImageView+URL.h"

@implementation ArmorBaseInfoView
@synthesize itemColorImageView;
@synthesize itemEffectImageView;
@synthesize itemIconImageView;
@synthesize typeLabel;
@synthesize subtypeLabel;
@synthesize classLabel;
@synthesize armorValueLabel;
@synthesize armorLabel;
@synthesize blockChanceValueLabel;
@synthesize blockChanceLabel;
@synthesize blockAmountValueLabel;
@synthesize blockAmountLabel;
@synthesize armor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
	self.itemColorImageView.layer.cornerRadius = 4;
	self.itemColorImageView.layer.borderWidth = 1;
}

- (void) setArmor:(NSDictionary *)value {
	NSDictionary* tmp = armor;
	armor = value;
	tmp = nil;
	
	D3APISession* session = [D3APISession sharedSession];
	NSString* color = [armor valueForKey:@"displayColor"];
	
	[self.itemIconImageView setImageWithContentsOfURL:[session itemImageURLWithItem:[armor valueForKey:@"icon"] size:@"large"]];
	
	self.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", color]];
	if (!self.itemColorImageView.image)
		self.itemColorImageView.image = [UIImage imageNamed:@"brown.png"];
	
	self.itemColorImageView.layer.borderColor = [[D3Utility itemBorderColorWithColorName:color highlighted:NO] CGColor];

	NSNumber* armorValue = [armor valueForKeyPath:@"armor.max"];
	if (armorValue)
		self.armorValueLabel.text = [NSString stringWithFormat:@"%.1f", [armorValue floatValue]];
	else {
		self.armorValueLabel.hidden = YES;
		self.armorLabel.hidden = YES;
		self.itemEffectImageView.hidden = YES;
	}
	
	NSNumber* blockChance = [armor valueForKeyPath:@"blockChance.max"];
	if (blockChance) {
		blockChanceValueLabel.text = [NSString stringWithFormat:@"%.f%%", [blockChance floatValue] * 100];
		[self.blockChanceValueLabel sizeToFit];
		self.blockChanceLabel.frame = CGRectMake(CGRectGetMaxX(self.blockChanceValueLabel.frame) + 5, self.blockChanceLabel.frame.origin.y, self.blockChanceLabel.frame.size.width, self.blockChanceLabel.frame.size.height);
	}
	else {
		blockChanceLabel.hidden = YES;
		blockChanceValueLabel.hidden = YES;
	}
	
	NSNumber* blockAmount = [armor valueForKeyPath:@"attributesRaw.Block_Amount_Item_Min.max"];
	NSNumber* blockAmountDelta = [armor valueForKeyPath:@"attributesRaw.Block_Amount_Item_Delta.max"];
	if (blockAmount && blockAmountDelta) {
		self.blockAmountValueLabel.text = [NSString stringWithFormat:@"%.1f-%.1f", [blockAmount floatValue], [blockAmount floatValue] + [blockAmountDelta floatValue]];
		[self.blockAmountValueLabel sizeToFit];
		self.blockAmountLabel.frame = CGRectMake(CGRectGetMaxX(self.blockAmountValueLabel.frame) + 5, self.blockAmountLabel.frame.origin.y, self.blockAmountLabel.frame.size.width, self.blockAmountLabel.frame.size.height);
	}
	else {
		self.blockAmountLabel.hidden = YES;
		self.blockAmountValueLabel.hidden = YES;
	}
	
	self.typeLabel.text = nil;
	self.subtypeLabel.text = [armor valueForKey:@"typeName"];
	self.subtypeLabel.textColor = [D3Utility colorWithColorName:color];
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
