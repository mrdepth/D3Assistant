//
//  HeroViewController.m
//  D3Assistant
//
//  Created by mr_depth on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "HeroViewController.h"
#import "EUOperationQueue.h"
#import "D3APISession.h"
#import "GearInfoViewController.h"

@interface HeroViewController ()
@property (nonatomic, weak) UIView* currentSection;

@end

@implementation HeroViewController
@synthesize headView;
@synthesize shouldersView;
@synthesize torsoView;
@synthesize feetView;
@synthesize handsView;
@synthesize legsView;
@synthesize bracersView;
@synthesize mainHandView;
@synthesize offHandView;
@synthesize waistView;
@synthesize leftFingerView;
@synthesize rightFingerView;
@synthesize neckView;
@synthesize gearsView;
@synthesize attributesTableView;
@synthesize attributesDataSource;
@synthesize backgroundImageView;
@synthesize skillsViewController;

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
	self.attributesDataSource.hero = self.hero;
	self.skillsViewController.hero = self.hero;
	self.title = [self.hero valueForKey:@"name"];
	
	self.attributesTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attributesBackground.png"]];
	self.attributesTableView.backgroundView.contentMode = UIViewContentModeScaleToFill;
	self.attributesTableView.backgroundView.contentStretch = CGRectMake(0, 0.1, 1, 0.8);
    // Do any additional setup after loading the view from its nib.
	
	NSString* class = [self.hero valueForKey:@"class"];
	NSInteger gender = [[self.hero valueForKey:@"gender"] integerValue];
	if ([class isEqualToString:@"wizard"])
		self.backgroundImageView.image = [UIImage imageNamed:gender == 0 ? @"gearWizardMale.png" : @"gearWizardFemale.png"];
	else if ([class isEqualToString:@"monk"])
		self.backgroundImageView.image = [UIImage imageNamed:gender == 0 ? @"gearMonkMale.png" : @"gearMonkFemale.png"];
	else if ([class isEqualToString:@"barbarian"])
		self.backgroundImageView.image = [UIImage imageNamed:gender == 0 ? @"gearBarbarianMale.png" : @"gearBarbarianFemale.png"];
	else if ([class isEqualToString:@"demon-hunter"])
		self.backgroundImageView.image = [UIImage imageNamed:gender == 0 ? @"gearDemonHunterMale.png" : @"gearDemonHunterFemale.png"];
	else if ([class isEqualToString:@"witch-doctor"])
		self.backgroundImageView.image = [UIImage imageNamed:gender == 0 ? @"gearWitchDoctorMale.png" : @"gearWitchDoctorFemale.png"];
	
	
	NSDictionary* gear = @{@"head" : headView, @"shoulders" : shouldersView, @"torso" : torsoView, @"feet" : feetView, @"hands" : handsView, @"legs" : legsView, @"bracers" : bracersView,
	@"mainHand" : mainHandView, @"offHand" : offHandView, @"waist" : waistView, @"leftFinger" : leftFingerView, @"rightFinger" : rightFingerView, @"neck" : neckView};
	
	
	__block __weak EUOperation* operation = [EUOperation operationWithIdentifier:@"GearViewController+Load" name:@"Loading"];
	
	NSMutableDictionary* gears = [NSMutableDictionary dictionary];
	
	[operation addExecutionBlock:^{
		@autoreleasepool {
			operation.progress = 0;
			D3APISession* session = [D3APISession sharedSession];
			
			NSDictionary* items = [self.hero valueForKey:@"items"];
			NSInteger n = items.count;
			NSInteger i = 0;
			for (NSString* key in [items allKeys]) {
				NSDictionary* item = [items valueForKey:key];
				item = [session itemInfoWithItemID:[item valueForKey:@"tooltipParams"] error:nil];
				if (item)
					[gears setValue:item forKey:key];

				operation.progress = (float) ++i / (float) n;
			}
		}
	}];
	
	[operation setCompletionBlockInCurrentThread:^{
		if (![operation isCancelled]) {
			for (NSString* key in [gears allKeys]) {
				GearView* gearView = [gear valueForKey:key];
				gearView.gear = [gears valueForKey:key];
				gearView.slot = key;
			}
		}
	}];
	
	[[EUOperationQueue sharedQueue] addOperation:operation];
	
	self.currentSection = self.gearsView;
	[self.view addSubview:self.currentSection];
	self.currentSection.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
}

- (void)viewDidUnload
{
    [self setHeadView:nil];
    [self setShouldersView:nil];
	[self setTorsoView:nil];
	[self setFeetView:nil];
	[self setHandsView:nil];
	[self setLegsView:nil];
	[self setBracersView:nil];
	[self setMainHandView:nil];
	[self setOffHandView:nil];
	[self setWaistView:nil];
	[self setLeftFingerView:nil];
	[self setRightFingerView:nil];
	[self setNeckView:nil];
	[self setAttributesTableView:nil];
	[self setAttributesDataSource:nil];
	[self setGearsView:nil];
    [self setBackgroundImageView:nil];
	[self setSkillsViewController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onChangeSection:(id)sender {
	[self.currentSection removeFromSuperview];
	NSArray* sections = @[gearsView, attributesTableView, self.skillsViewController.view];
	self.currentSection = [sections objectAtIndex:[sender selectedSegmentIndex]];
	[self.view addSubview:self.currentSection];
	self.currentSection.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
}

#pragma mark - GearViewDelegate

- (void) didSelectGearView:(GearView*) gearView {
	if (gearView.gear) {
		GearInfoViewController* controller = [[GearInfoViewController alloc] initWithNibName:@"GearInfoViewController" bundle:nil];
		controller.gear = gearView.gear;
		controller.slot = gearView.slot;
		[self.navigationController pushViewController:controller animated:YES];
	}
}

@end
