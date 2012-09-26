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
#import "SocketView.h"

#import "D3APISession.h"

@interface GearView()
@property (nonatomic, strong) UIImageView* itemColorImageView;
@property (nonatomic, strong) UIImageView* itemIconImageView;
@property (nonatomic, strong) NSMutableArray* sockets;
@property (nonatomic, assign) BOOL highlighted;

- (void) onTap:(UITapGestureRecognizer*) recognizer;
- (UIImage*) placeholderImage;

@end

@implementation GearView
@synthesize gear;
@synthesize slot;
@synthesize delegate;
@synthesize highlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
	self.itemColorImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	self.itemColorImageView.frame = self.bounds;
	self.itemColorImageView.contentMode = UIViewContentModeScaleToFill;
//	self.itemColorImageView.layer.cornerRadius = 4;
	self.itemColorImageView.layer.borderWidth = 1;
	self.itemColorImageView.clipsToBounds = YES;
	self.itemColorImageView.contentStretch = CGRectMake(0.1, 0.1, 0.8, 0.8);
	self.itemColorImageView.userInteractionEnabled = NO;
	self.itemIconImageView.userInteractionEnabled = NO;
	
	self.itemIconImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	self.itemIconImageView.contentMode = UIViewContentModeScaleAspectFill;

	self.itemColorImageView.layer.borderColor = [[UIColor colorWithWhite:0.4 alpha:1] CGColor];
	self.itemColorImageView.image = [self placeholderImage];

	[self addSubview:self.itemColorImageView];
	[self addSubview:self.itemIconImageView];
	
	[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
}

- (void) setGear:(NSDictionary *)value {
	gear = value;
	
	for (SocketView* view in self.sockets)
		[view removeFromSuperview];
	
	if (gear) {
		self.sockets = [NSMutableArray array];
		
		D3APISession* session = [D3APISession sharedSession];
		NSString* color = [gear valueForKey:@"displayColor"];
		
		[self.itemIconImageView setImageWithContentsOfURL:[session itemImageURLWithItem:[gear valueForKey:@"icon"] size:@"large"]];
		self.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", color]];
		if (!self.itemColorImageView.image)
			self.itemColorImageView.image = [UIImage imageNamed:@"brown.png"];
		
		self.itemColorImageView.layer.borderColor = [[D3Utility itemBorderColorWithColorName:color highlighted:NO] CGColor];
		
		NSArray* gems = [gear valueForKey:@"gems"];
		NSInteger numberOfGems = gems.count;
		CGRect frame = CGRectMake(self.frame.size.width / 2.0 - 12.0, self.frame.size.height / 2.0 - 24.0 * numberOfGems / 2.0, 24, 24);
		
		for (NSDictionary* gem in gems) {
			SocketView* socket = [[SocketView alloc] initWithFrame:frame];
			[socket.gemImageView setImageWithContentsOfURL:[session itemImageURLWithItem:[gem valueForKeyPath:@"item.icon"] size:@"small"]];
			[self addSubview:socket];
			[self.sockets addObject:socket];
			frame.origin.y += frame.size.height;
		}
	}
	else {
		self.itemIconImageView.image = nil;
		self.itemColorImageView.layer.borderColor = [[UIColor colorWithWhite:0.4 alpha:1] CGColor];
		self.itemColorImageView.image = [self placeholderImage];
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = YES;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = NO;
}

#pragma mark - Private

- (void) setHighlighted:(BOOL)value {
	highlighted = value;
	if (self.gear) {
		NSString* color = [self.gear valueForKey:@"displayColor"];
		
		if (highlighted) {
			self.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted.png", color]];
			if (!self.itemColorImageView.image)
				self.itemColorImageView.image = [UIImage imageNamed:@"brownHighlighted.png"];
		}
		else {
			self.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", color]];
			if (!self.itemColorImageView.image)
				self.itemColorImageView.image = [UIImage imageNamed:@"brown.png"];
		}
		
		self.itemColorImageView.layer.borderColor = [[D3Utility itemBorderColorWithColorName:color highlighted:highlighted] CGColor];
	}
}

- (void) onTap:(UITapGestureRecognizer*) recognizer {
	[self.delegate didSelectGearView:self];
}

- (UIImage*) placeholderImage {
	NSDictionary* map = @{@"head" : @"gearViewHead.png", @"shoulders" : @"gearViewShoulders.png", @"torso" : @"gearViewTorso.png", @"feet" : @"gearViewFeet.png", @"hands" : @"gearViewHands.png",
	@"legs" : @"gearViewLegs.png", @"bracers" : @"gearViewBracers.png",	@"mainHand" : @"gearViewMainHand.png", @"offHand" : @"gearViewOffHand.png", @"waist" : @"gearViewWaist.png",
	@"leftFinger" : @"gearViewFinger.png",  @"rightFinger" : @"gearViewFinger.png", @"neck" : @"gearViewNeck.png"};
	return [UIImage imageNamed:[map valueForKey:self.slot]];
}

@end
