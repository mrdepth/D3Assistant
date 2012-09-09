//
//  SkillsViewController.m
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "SkillsViewController.h"

@interface SkillsViewController ()

@end

@implementation SkillsViewController
@synthesize scrollView;
@synthesize contentView;
@synthesize activeSkills;
@synthesize passiveSkills;
@synthesize hero;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView addSubview:self.contentView];
	self.scrollView.contentSize = self.contentView.frame.size;
	
	NSArray* active = [self.hero valueForKeyPath:@"skills.active"];
	NSArray* passive = [self.hero valueForKeyPath:@"skills.passive"];
	
	for (ActiveSkillView* skillView in self.activeSkills) {
		skillView.order = skillView.tag;
		if (skillView.order < active.count) {
			NSDictionary* item = [active objectAtIndex:skillView.order];
			skillView.skill = [item valueForKey:@"skill"];
			skillView.rune = [item valueForKey:@"rune"];
		}
	}
	
	for (PassiveSkillView* skillView in self.passiveSkills) {
		if (skillView.tag < passive.count) {
			NSDictionary* item = [passive objectAtIndex:skillView.tag];
			skillView.skill = [item valueForKey:@"skill"];
		}
	}

	
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setContentView:nil];
	[self setActiveSkills:nil];
	[self setPassiveSkills:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setHero:(NSDictionary *)value {
	NSDictionary* tmp = hero;
	hero = value;
	tmp = nil;
}

#pragma mark - ActiveSkillViewDelegate

- (void) didSelectActiveSkillView:(ActiveSkillView*) activeSkillView {
	
}

@end
