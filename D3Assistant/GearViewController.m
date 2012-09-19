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
@synthesize fallen;

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

- (void) setHero:(NSDictionary *)aHero fallen:(BOOL) isFallen {
	hero = aHero;
	fallen = isFallen;
	
	if ([self isViewLoaded])
		[self reload];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[GearInfoViewController class]]) {
		GearInfoViewController* controller = (GearInfoViewController*) segue.destinationViewController;
		controller.hero = self.hero;
		controller.gear = [sender gear];
		controller.slot = [sender slot];
	}
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
	self.heroNameLabel.text = [self.hero valueForKey:@"name"];
	
	NSString* class = [self.hero valueForKey:@"class"];
	NSString* deviceSuffix = nil;
	NSString* className = nil;
	NSString* gender = [[self.hero valueForKey:@"gender"] integerValue] ? @"Female" : @"Male";

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		deviceSuffix = @"-iPad";
	else
		deviceSuffix = @"";
		
	if ([class isEqualToString:@"wizard"])
		className = @"Wizard";
	else if ([class isEqualToString:@"monk"])
		className = @"Monk";
	else if ([class isEqualToString:@"barbarian"])
		className = @"Barbarian";
	else if ([class isEqualToString:@"demon-hunter"])
		className = @"DemonHunter";
	else if ([class isEqualToString:@"witch-doctor"])
		className = @"WitchDoctor";
	else
		className = @"Wizard";

	self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gear%@%@%@.png", className, gender, deviceSuffix]];
	
	
	NSDictionary* gear = @{@"head" : self.headView, @"shoulders" : self.shouldersView, @"torso" : self.torsoView, @"feet" : self.feetView, @"hands" : self.handsView,
	@"legs" : self.legsView, @"bracers" : self.bracersView,	@"mainHand" : self.mainHandView, @"offHand" : self.offHandView, @"waist" : self.waistView,
	@"leftFinger" : self.leftFingerView, @"rightFinger" : self.rightFingerView, @"neck" : self.neckView};
	
	for (GearView* gearView in [gear allValues]) {
		gearView.gear = nil;
	}
	
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
}

@end
