//
//  GearViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "GearViewController.h"
#import "EUOperationQueue.h"
#import "D3APISession.h"
#import "GearInfoViewController.h"

@interface GearViewController ()
- (void) reload;
@end

@implementation GearViewController
@synthesize hero;
@synthesize gears;
@synthesize party;
@synthesize compareHero;
@synthesize compareGears;
@synthesize compareParty;
@synthesize activeCompareHero;

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
	[self reload];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.headView = nil;
	self.shouldersView = nil;
	self.torsoView = nil;
	self.feetView = nil;
	self.handsView = nil;
	self.legsView = nil;
	self.bracersView = nil;
	self.mainHandView = nil;
	self.offHandView = nil;
	self.waistView = nil;
	self.leftFingerView = nil;
	self.rightFingerView = nil;
	self.neckView = nil;
	self.backgroundImageView = nil;
	self.heroNameLabel = nil;
}

- (void) setHero:(NSDictionary *)aHero {
	hero = aHero;
	
	if ([self isViewLoaded])
		[self reload];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[GearInfoViewController class]]) {
		GearInfoViewController* controller = (GearInfoViewController*) segue.destinationViewController;
		controller.hero = self.hero;
		controller.compareHero = self.compareHero;
		controller.gear = [self.gears valueForKey:[sender slot]];
		controller.compareGear = [self.compareGears valueForKey:[sender slot]];
		controller.slot = [sender slot];
		controller.party = self.party;
		controller.activeCompareHero = self.activeCompareHero;
	}
}

- (void) setGears:(NSDictionary *)value {
	gears = value;
	[self reload];
}

- (void) setCompareGears:(NSDictionary *)value {
	compareGears = value;
	[self reload];
}

- (void) setActiveCompareHero:(BOOL)value {
	activeCompareHero = value;
	[self reload];
}

#pragma mark - GearViewDelegate

- (void) didSelectGearView:(GearView*) gearView {
	if (gearView.gear) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			[self performSegueWithIdentifier:[NSString stringWithFormat:@"%@Info", gearView.slot] sender:gearView];
		else
			[self performSegueWithIdentifier:@"GearInfo" sender:gearView];
	}
}

#pragma mark - Private

- (void) reload {
	NSDictionary* currentHero = self.activeCompareHero ? self.compareHero : self.hero;
	NSDictionary* currentGears = self.activeCompareHero ? self.compareGears : self.gears;
	
	self.heroNameLabel.text = [currentHero valueForKey:@"name"];
	
	NSString* heroClass = [currentHero valueForKey:@"class"];
	NSString* deviceSuffix = nil;
	NSString* className = nil;

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		deviceSuffix = @"-iPad";
	else
		deviceSuffix = @"";
		
	if ([heroClass isEqualToString:@"wizard"])
		className = @"Wizard";
	else if ([heroClass isEqualToString:@"monk"])
		className = @"Monk";
	else if ([heroClass isEqualToString:@"barbarian"])
		className = @"Barbarian";
	else if ([heroClass isEqualToString:@"demon-hunter"])
		className = @"DemonHunter";
	else if ([heroClass isEqualToString:@"witch-doctor"])
		className = @"WitchDoctor";
	else
		className = @"Wizard";

	//self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gear%@%@%@.png", className, gender, deviceSuffix]];
	self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gear%@%@.png", className, deviceSuffix]];
	
	for (GearView* gearView in @[self.headView, self.shouldersView, self.torsoView, self.feetView, self.feetView, self.handsView, self.legsView,
		 self.bracersView, self.mainHandView, self.offHandView, self.waistView, self.leftFingerView, self.rightFingerView, self.neckView]) {
		gearView.gear = [currentGears valueForKey:gearView.slot];
	}
}

@end
