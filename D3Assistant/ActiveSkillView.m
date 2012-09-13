//
//  ActiveSkillView.m
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ActiveSkillView.h"
#import "D3APISession.h"
#import "UIImageView+URL.h"

@interface ActiveSkillView()

@property (nonatomic, assign) BOOL highlighted;

@end

@implementation ActiveSkillView
@synthesize contentView;
@synthesize skillImageView;
@synthesize runeImageView;
@synthesize skillNameLabel;
@synthesize runeNameLabel;
@synthesize skillOrderLabel;
@synthesize skillOrderImageView;
@synthesize frameImageView;
@synthesize delegate;

@synthesize skill;
@synthesize rune;
@synthesize order;

@synthesize highlighted;

- (void) awakeFromNib {
	[[NSBundle mainBundle] loadNibNamed:@"ActiveSkillView" owner:self options:nil];
	[self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
	[self addSubview:contentView];
}

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

- (IBAction)onTap:(id)sender {
	[self.delegate didSelectActiveSkillView:self];
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

- (void) setSkill:(NSDictionary *)value {
	skill = value;
	
	if (skill) {
		self.skillNameLabel.text = [skill valueForKey:@"name"];
		[self.skillImageView setImageWithContentsOfURL:[[D3APISession sharedSession] skillImageURLWithItem:[skill valueForKey:@"icon"] size:@"42"]];
	}
	else {
		self.skillNameLabel.text = nil;
		self.skillImageView.image = nil;
	}
}

- (void) setRune:(NSDictionary *)value {
	rune = value;
	
	if (rune) {
		self.runeNameLabel.text = [rune valueForKey:@"name"];
		self.runeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"runeSmall%@.png", [[rune valueForKey:@"type"] capitalizedString]]];
	}
	else {
		self.runeNameLabel.text = nil;
		self.runeImageView.image = nil;
	}
}

- (void) setOrder:(NSInteger)value {
	order = value;
	if (order == 0)
		self.skillOrderImageView.image = [UIImage imageNamed:@"skillPrimary.png"];
	else if (order == 1)
		self.skillOrderImageView.image = [UIImage imageNamed:@"skillSecondary.png"];
	else
		self.skillOrderLabel.text = [NSString stringWithFormat:@"%d", value - 1];
}

#pragma mark - Private

- (void) setHighlighted:(BOOL)value {
	highlighted = value;
	
	self.frameImageView.image = [UIImage imageNamed:highlighted ? @"skillActiveFrameHighlighted.png" : @"skillActiveFrame.png"];
	
}

@end
