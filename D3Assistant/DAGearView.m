//
//  DAGearView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAGearView.h"
#import "UIImageView+URL.h"
#import "DAStorage.h"

@interface DAGearView()
@property (nonatomic, strong, readwrite) NSString* slot;
@property (nonatomic, strong) NSString* placeholderImage;

@end

@implementation DAGearView

- (void) awakeFromNib {
	UIView* view = [[[UINib nibWithNibName:@"DAGearView" bundle:nil] instantiateWithOwner:self options:nil] lastObject];
	view.frame = self.bounds;
	view.translatesAutoresizingMaskIntoConstraints = YES;
	[self addSubview:view];
/*	NSDictionary* bindings = NSDictionaryOfVariableBindings(view);
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[view]-0-|"
																 options:0
																 metrics:nil
																   views:bindings]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
																 options:0
																 metrics:nil
																   views:bindings]];*/
	self.itemImageView.image = [UIImage imageNamed:self.placeholderImage];
}

- (void) setGear:(DAGear *)gear {
	_gear = gear;
	NSArray* socketViews = @[self.socketImageView1, self.socketImageView2, self.socketImageView3];

	if (gear) {
		[self.itemImageView setImageWithContentsOfURL:[gear.item imageURLWithSize:DAItemImageSizeLarge]];
		self.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", gear.item.itemInfo.displayColor]];
		self.itemColorImageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted.png", gear.item.itemInfo.displayColor]];
		
		NSInteger i = 0;
		if ([gear.item.itemInfo.gems isKindOfClass:[NSArray class]]) {
			for (NSDictionary* gem in  gear.item.itemInfo.gems) {
				[socketViews[i] setImageWithContentsOfURL:[DAItem imageURLWithName:gem[@"item"][@"icon"] size:DAItemImageSizeSmall]];
				if (i >= 3)
					break;
				i++;
			}
			for (;i < 3; i++) {
				[(UIImageView*) socketViews[i] setImage:nil];
			}
		}
	}
	else {
		self.itemImageView.image = [UIImage imageNamed:self.placeholderImage];
		self.itemColorImageView.image = nil;
		for (NSInteger i = 0; i < 3; i++) {
			[(UIImageView*) socketViews[i] setImage:nil];
		}
	}
}

- (void) setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	self.itemColorImageView.highlighted = highlighted;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
