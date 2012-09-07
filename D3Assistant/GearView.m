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

@end

@implementation GearView
@synthesize gear;

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
	self.itemColorImageView.clipsToBounds = YES;

	self.itemIconImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	self.itemIconImageView.contentMode = UIViewContentModeScaleAspectFill;

	[self addSubview:self.itemColorImageView];
	[self addSubview:self.itemIconImageView];
}

- (void) setGear:(NSDictionary *)value {
	NSDictionary* tmp = gear;
	gear = value;
	tmp = nil;
	
	for (SocketView* view in self.sockets)
		[view removeFromSuperview];
	self.sockets = [NSMutableArray array];
	
	D3APISession* session = [D3APISession sharedSession];
	NSString* color = [gear valueForKey:@"displayColor"];
	
	[self.itemIconImageView setImageWithContentsOfURL:[session itemImageURLWithItem:[gear valueForKey:@"icon"] size:@"large"]];
	self.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", color]];
	if (!self.itemColorImageView.image)
		self.itemColorImageView.image = [UIImage imageNamed:@"brown.png"];

	if ([color isEqualToString:@"blue"])
		self.itemColorImageView.layer.borderColor = [[UIColor colorWithNumber:@(0x8bc8d4ff)] CGColor];
	else if ([color isEqualToString:@"brown"])
		self.itemColorImageView.layer.borderColor = [[UIColor colorWithNumber:@(0x8bc8d4ff)] CGColor];
	else if ([color isEqualToString:@"green"])
		self.itemColorImageView.layer.borderColor = [[UIColor colorWithNumber:@(0x8bc8d4ff)] CGColor];
	else if ([color isEqualToString:@"orange"])
		self.itemColorImageView.layer.borderColor = [[UIColor colorWithNumber:@(0x8bc8d4ff)] CGColor];
	else if ([color isEqualToString:@"yellow"])
		self.itemColorImageView.layer.borderColor = [[UIColor colorWithNumber:@(0x8bc8d4ff)] CGColor];
	else
		self.itemColorImageView.layer.borderColor = [[UIColor colorWithNumber:@(0x8bc8d4ff)] CGColor];
	
	NSArray* gems = [gear valueForKey:@"gems"];
	NSInteger numberOfGems = gems.count;
	CGRect frame = CGRectMake(self.frame.size.width / 2.0 - 12.0, self.frame.size.height / 2.0 - 24.0 * numberOfGems / 2.0, 24, 24);

	for (NSDictionary* gem in gems) {
		SocketView* socket = [[SocketView alloc] initWithFrame:frame];
		[socket.gemImageView setImageWithContentsOfURL:[session itemImageURLWithItem:[gem valueForKeyPath:@"item.icon"] size:@"small"]];
		[self addSubview:socket];
		frame.origin.y += frame.size.height;
	}
}

@end
