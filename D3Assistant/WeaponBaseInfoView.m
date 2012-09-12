//
//  WeaponBaseInfoView.h
//  D3Assistant
//
//  Created by mr_depth on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "WeaponBaseInfoView.h"
#import "D3APISession.h"
#import "UIImageView+URL.h"

@implementation WeaponBaseInfoView
@synthesize itemColorImageView;
@synthesize itemEffectImageView;
@synthesize itemIconImageView;
@synthesize typeLabel;
@synthesize subtypeLabel;
@synthesize classLabel;
@synthesize dpsLabel;
@synthesize damageValueLabel;
@synthesize damageLabel;
@synthesize apsValueLabel;
@synthesize apsLabel;
@synthesize weapon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
//	self.itemColorImageView.layer.cornerRadius = 4;
//	self.itemColorImageView.layer.borderWidth = 1;
}

- (void) setWeapon:(NSDictionary *)value {
	weapon = value;
	
	D3APISession* session = [D3APISession sharedSession];
	NSString* color = [weapon valueForKey:@"displayColor"];
	
	[self.itemIconImageView setImageWithContentsOfURL:[session itemImageURLWithItem:[weapon valueForKey:@"icon"] size:@"large"]];

	self.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", color]];
	if (!self.itemColorImageView.image)
		self.itemColorImageView.image = [UIImage imageNamed:@"brown.png"];
	
//	self.itemColorImageView.layer.borderColor = [[D3Utility itemBorderColorWithColorName:color highlighted:NO] CGColor];
	
	self.dpsLabel.text = [NSString stringWithFormat:@"%.1f", [[weapon valueForKeyPath:@"dps.max"] floatValue]];
	self.damageValueLabel.text = [NSString stringWithFormat:@"%.1f-%.1f", [[weapon valueForKeyPath:@"minDamage.max"] floatValue], [[weapon valueForKeyPath:@"maxDamage.max"] floatValue]];
	self.apsValueLabel.text = [NSString stringWithFormat:@"%.1f", [[weapon valueForKeyPath:@"attacksPerSecond.max"] floatValue]];
	self.typeLabel.text = nil;
	self.subtypeLabel.text = [weapon valueForKey:@"typeName"];
	self.subtypeLabel.textColor = [D3Utility colorWithColorName:color];

	[self.damageValueLabel sizeToFit];
	[self.apsValueLabel sizeToFit];
	
	self.damageLabel.frame = CGRectMake(CGRectGetMaxX(self.damageValueLabel.frame) + 5, self.damageLabel.frame.origin.y, self.damageLabel.frame.size.width, self.damageLabel.frame.size.height);
	self.apsLabel.frame = CGRectMake(CGRectGetMaxX(self.apsValueLabel.frame) + 5, self.apsLabel.frame.origin.y, self.apsLabel.frame.size.width, self.apsLabel.frame.size.height);
	
	NSString* effect = nil;
	for (NSString* key in [[self.weapon valueForKey:@"attributesRaw"] allKeys]) {
		if ([key rangeOfString:@"#Fire"].location != NSNotFound) {
			effect = @"fire.png";
			break;
		}
		else if ([key rangeOfString:@"#Cold"].location != NSNotFound) {
			effect = @"cold.png";
			break;
		}
		else if ([key rangeOfString:@"#Arcane"].location != NSNotFound) {
			effect = @"arcane.png";
			break;
		}
		else if ([key rangeOfString:@"#Holy"].location != NSNotFound) {
			effect = @"holy.png";
			break;
		}
		else if ([key rangeOfString:@"#Poison"].location != NSNotFound) {
			effect = @"poison.png";
			break;
		}
	}
	
	if (effect)
		self.itemEffectImageView.image = [UIImage imageNamed:effect];
	else
		self.itemEffectImageView.image = nil;
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
