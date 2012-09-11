//
//  PassiveSkillView.m
//  D3Assistant
//
//  Created by mr_depth on 09.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "PassiveSkillView.h"
#import "D3APISession.h"
#import "UIImageView+URL.h"

@interface PassiveSkillView()

@property (nonatomic, assign) BOOL highlighted;

@end

@implementation PassiveSkillView
@synthesize contentView;
@synthesize skillImageView;
@synthesize skillNameLabel;
@synthesize frameImageView;
@synthesize delegate;

@synthesize skill;
@synthesize highlighted;

- (void) awakeFromNib {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		[[NSBundle mainBundle] loadNibNamed:@"PassiveSkillView-iPad" owner:self options:nil];
	else
		[[NSBundle mainBundle] loadNibNamed:@"PassiveSkillView" owner:self options:nil];
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
	[self.delegate didSelectPassiveSkillView:self];
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
	NSDictionary* tmp = skill;
	skill = value;
	tmp = nil;
	
	if (skill) {
		self.skillNameLabel.text = [skill valueForKey:@"name"];
		[self.skillImageView setImageWithContentsOfURL:[[D3APISession sharedSession] skillImageURLWithItem:[skill valueForKey:@"icon"] size:@"42"]];
	}
	else {
		self.skillNameLabel.text = nil;
		self.skillImageView.image = nil;
	}
}

#pragma mark - Private

- (void) setHighlighted:(BOOL)value {
	highlighted = value;
	self.frameImageView.image = [UIImage imageNamed:highlighted ? @"skillPassiveFrameHighlighted.png" : @"skillPassiveFrame.png"];
	
}

@end
