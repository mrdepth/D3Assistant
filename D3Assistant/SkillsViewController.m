//
//  SkillsViewController.m
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "SkillsViewController.h"
#import "SkillInfoViewController.h"

@interface SkillsViewController ()
@property (nonatomic, strong) UIPopoverController* skillInfoPopoverController;
- (void) reload;
@end

@implementation SkillsViewController
@synthesize scrollView;
@synthesize contentView;
@synthesize activeSkills;
@synthesize passiveSkills;
@synthesize hero;
@synthesize navigationController;

@synthesize skillInfoPopoverController;

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
	if (self.scrollView) {
		[self.scrollView addSubview:self.contentView];
		self.scrollView.contentSize = self.contentView.frame.size;
	}
	

	[self reload];
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
	hero = value;
	
	if ([self isViewLoaded])
		[self reload];
}

- (UINavigationController*) navigationController {
	if (navigationController)
		return navigationController;
	else
		return [super navigationController];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([sender isKindOfClass:[ActiveSkillView class]]) {
		SkillInfoViewController* controller = (SkillInfoViewController*) segue.destinationViewController;
		controller.hero = self.hero;
		NSDictionary* rune = [sender rune];
		controller.activeSkill = [sender skill];
		if (rune)
			controller.runes = @[rune];
	}
	if ([sender isKindOfClass:[PassiveSkillView class]]) {
		SkillInfoViewController* controller = (SkillInfoViewController*) segue.destinationViewController;
		controller.hero = self.hero;
		controller.passiveSkill = [sender skill];
	}
}

#pragma mark - ActiveSkillViewDelegate

- (void) didSelectActiveSkillView:(ActiveSkillView*) activeSkillView {
	if (activeSkillView.skill) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			[self performSegueWithIdentifier:[NSString stringWithFormat:@"ActiveSkill%d", activeSkillView.tag] sender:activeSkillView];
		else
			[self performSegueWithIdentifier:@"ActiveSkillInfo" sender:activeSkillView];
	}
}

#pragma mark - PassiveSkillViewDelegate

- (void) didSelectPassiveSkillView:(PassiveSkillView*) passiveSkillView {
	if (passiveSkillView.skill) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			[self performSegueWithIdentifier:[NSString stringWithFormat:@"PassiveSkill%d", passiveSkillView.tag] sender:passiveSkillView];
		else
			[self performSegueWithIdentifier:@"PassiveSkillInfo" sender:passiveSkillView];
	}
}

#pragma mark - Private

- (void) reload {
	NSArray* active = [self.hero valueForKeyPath:@"skills.active"];
	NSArray* passive = [self.hero valueForKeyPath:@"skills.passive"];
	
	for (ActiveSkillView* skillView in self.activeSkills) {
		skillView.order = skillView.tag;
		if (skillView.order < active.count) {
			NSDictionary* item = [active objectAtIndex:skillView.order];
			skillView.skill = [item valueForKey:@"skill"];
			skillView.rune = [item valueForKey:@"rune"];
		}
		else {
			skillView.skill = nil;
			skillView.rune = nil;
		}
	}
	
	for (PassiveSkillView* skillView in self.passiveSkills) {
		if (skillView.tag < passive.count) {
			NSDictionary* item = [passive objectAtIndex:skillView.tag];
			skillView.skill = [item valueForKey:@"skill"];
		}
		else
			skillView.skill = nil;
	}
}

@end
