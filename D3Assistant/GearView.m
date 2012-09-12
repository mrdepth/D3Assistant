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
	self.itemColorImageView.layer.cornerRadius = 4;
	self.itemColorImageView.layer.borderWidth = 1;
	self.itemColorImageView.layer.borderColor = [[UIColor clearColor] CGColor];
	self.itemColorImageView.clipsToBounds = YES;

	self.itemIconImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	self.itemIconImageView.contentMode = UIViewContentModeScaleAspectFill;

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
		self.itemColorImageView.image = nil;
		self.itemIconImageView.image = nil;
		self.itemColorImageView.layer.borderColor = [[UIColor clearColor] CGColor];
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

@end
