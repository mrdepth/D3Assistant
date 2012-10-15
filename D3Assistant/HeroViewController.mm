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
- (void) reload;
- (void) loadHero:(NSDictionary*) hero withCompletion:(void(^)(d3ce::Party* party, NSDictionary* gears)) completion;
- (IBAction)onChangeHero:(id)sender;
@end

@implementation HeroViewController {
	d3ce::Engine* engine;
	d3ce::Party* party;
	d3ce::Hero* d3ceHero;
	d3ce::Party* compareParty;
	d3ce::Hero* compareD3ceHero;
}
@synthesize sectionsControl;
@synthesize hero;
@synthesize compareHero;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
	if (party)
		delete party;
	if (compareParty)
		delete compareParty;
	if (engine)
		delete engine;
}

- (void)viewDidLoad
{
	self.title = @"";
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.gearAttributesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GearAttributesViewController"];
		self.skillsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SkillsViewController"];
		
		[self addChildViewController:self.gearAttributesViewController];
		[self.view addSubview:self.gearAttributesViewController.view];
		[self.gearAttributesViewController didMoveToParentViewController:self];

		self.gearViewController = self.gearAttributesViewController.gearViewController;
		self.attributesViewController = self.gearAttributesViewController.attributesViewController;
	}
	else {
		self.skillsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SkillsViewController"];
		self.attributesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AttributesViewController"];
		self.gearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GearViewController"];

		[self addChildViewController:self.gearViewController];
		[self.contentView addSubview:self.gearViewController.view];
		[self.gearViewController didMoveToParentViewController:self];
	}
	[self reload];
}

- (void) viewDidLayoutSubviews {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.gearAttributesViewController.view.frame = self.view.bounds;
		self.skillsViewController.view.frame = self.view.bounds;
	}
	else {
		self.gearViewController.view.frame = self.contentView.bounds;
		self.attributesViewController.view.frame = self.contentView.bounds;
		self.skillsViewController.view.frame = self.contentView.bounds;
	}
}

- (void)viewDidUnload
{
	[self setSectionsControl:nil];
	[self setContentView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"SelectCompareHero"])
		[(HeroSelectionViewController*) [segue.destinationViewController topViewController] setDelegate:self];
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	else
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskLandscape;
}*/

- (IBAction)onChangeSection:(id)sender {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIViewController* childViewController = [self.childViewControllers objectAtIndex:0];
		UIViewController* newViewController = [sender selectedSegmentIndex] == 0 ? self.gearAttributesViewController : self.skillsViewController;
		
		if (childViewController != newViewController) {
			[self addChildViewController:newViewController];
			newViewController.view.frame = self.view.bounds;
			[self transitionFromViewController:childViewController
							  toViewController:newViewController
									  duration:0
									   options:0
									animations:nil
									completion:^(BOOL finished) {
										[newViewController didMoveToParentViewController:self];
										[childViewController removeFromParentViewController];
									}];
		}
	}
	else {
		UIViewController* childViewController = [self.childViewControllers objectAtIndex:0];
		UIViewController* newViewController = nil;
		switch ([sender selectedSegmentIndex]) {
			case 0:
				newViewController = self.gearViewController;
				break;
			case 1:
				newViewController = self.attributesViewController;
				break;
			case 2:
				newViewController = self.skillsViewController;
				break;
			default:
				break;
		}
		if (childViewController != newViewController) {
			[self addChildViewController:newViewController];
			newViewController.view.frame = self.contentView.bounds;
			[self transitionFromViewController:childViewController
							  toViewController:newViewController
									  duration:0
									   options:0
									animations:nil
									completion:^(BOOL finished) {
										[newViewController didMoveToParentViewController:self];
										[childViewController removeFromParentViewController];
									}];
		}
	}

}

- (void) setHero:(NSDictionary *)aHero {
	hero = aHero;
	
	if ([self isViewLoaded])
		[self reload];
}

- (void) setCompareHero:(NSDictionary *)aHero {
	compareHero = aHero;
	[self loadHero:aHero
	withCompletion:^(d3ce::Party *aParty, NSDictionary *gears) {
		if (compareParty)
			delete compareParty;
		compareParty = aParty;
		
		compareD3ceHero = compareParty ? compareParty->getHeroes().front() : NULL;
		self.gearViewController.compareHero = aHero;
		self.gearViewController.compareParty = compareParty;
		self.gearViewController.compareGears = gears;
		self.gearViewController.activeCompareHero = NO;
		self.attributesViewController.hero = self.hero;
		self.attributesViewController.d3ceHero = party->getHeroes().front();
		self.skillsViewController.hero = self.hero;
	}];
	
	if (compareHero) {
		UISegmentedControl* control = [[UISegmentedControl alloc] initWithItems:@[[self.hero valueForKey:@"name"], [compareHero valueForKey:@"name"]]];
		control.segmentedControlStyle = UISegmentedControlStyleBar;
		control.selectedSegmentIndex = 0;
		[control addTarget:self action:@selector(onChangeHero:) forControlEvents:UIControlEventValueChanged];
		self.navigationItem.titleView = control;
	}
}

#pragma mark - HeroSelectionViewControllerDelegate

- (void) heroSelectionViewController:(HeroSelectionViewController*) controller didSelectHero:(NSDictionary*) aHero {
	self.compareHero = aHero;
}

#pragma mark - Private

- (void) reload {
	self.attributesViewController.hero = self.hero;
	self.gearViewController.hero = self.hero;
	[self.skillsViewController setHero:self.hero];
	
	if (!self.hero) {
		[self.navigationItem setLeftBarButtonItem:nil animated:YES];
		self.title = @"";
	}
	else
		self.title = [self.hero valueForKey:@"name"];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (![hero valueForKey:@"skills"]) {
			[self.navigationItem setLeftBarButtonItem:nil animated:YES];
			UIViewController* childViewController = [self.childViewControllers objectAtIndex:0];
			if (childViewController != self.gearAttributesViewController) {
				self.sectionsControl.selectedSegmentIndex = 0;
				[self addChildViewController:self.gearAttributesViewController];
				[self transitionFromViewController:childViewController
								  toViewController:self.gearAttributesViewController
										  duration:0
										   options:0
										animations:nil
										completion:^(BOOL finished) {
											[childViewController removeFromParentViewController];
											[self.gearAttributesViewController didMoveToParentViewController:self];
										}];
			}
			[[self childViewControllers] objectAtIndex:0];
		}
		else {
			if (!self.navigationItem.leftBarButtonItem && self.hero)
				[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.sectionsControl] animated:YES];
		}
	}
	else {
		if (![hero valueForKey:@"skills"])
			[self.sectionsControl removeSegmentAtIndex:2 animated:NO];
	}
	
	[self loadHero:hero
	withCompletion:^(d3ce::Party *aParty, NSDictionary *gears) {
		if (party)
			delete party;
		party = aParty;
		
		d3ceHero = party ? party->getHeroes().front() : NULL;
		self.gearViewController.gears = gears;
		self.gearViewController.party = party;
		self.attributesViewController.d3ceHero = d3ceHero;

	}];
}

- (void) loadHero:(NSDictionary*) aHero withCompletion:(void(^)(d3ce::Party* party, NSDictionary* gears)) completion {
	if (!aHero)
		return;
	
	__block __weak EUOperation* operation = [EUOperation operationWithIdentifier:@"HeroViewController+Load" name:@"Loading"];
	
	NSMutableDictionary* gears = [NSMutableDictionary dictionary];
	if (!engine)
		engine = [D3CEHelper newEgine];
	d3ce::Party* aParty = new d3ce::Party(engine);
	d3ce::Hero* aD3ceHero = [D3CEHelper addHeroFromDictionary:aHero toParty:aParty];
	
	[operation addExecutionBlock:^{
		@autoreleasepool {
			operation.progress = 0;
			D3APISession* session = [D3APISession sharedSession];
			
			NSDictionary* items = [aHero valueForKey:@"items"];
			NSInteger n = items.count;
			NSInteger i = 0;
			for (NSString* key in [items allKeys]) {
				NSDictionary* item = [items valueForKey:key];
				item = [session itemInfoWithItemID:[item valueForKey:@"tooltipParams"] error:nil];
				if (item)
					[gears setValue:item forKey:key];
				if (aD3ceHero)
					[D3CEHelper addItemFromDictionary:item toHero:aD3ceHero slot:[D3CEHelper slotFromString:key] replaceExisting:NO];
				
				operation.progress = (float) ++i / (float) n;
			}
			
			//			for (NSDictionary* skill in [self.hero valueForKeyPath:@"skills.active"])
			//				[D3CEHelper addSkillFromDictionary:skill toHero:d3ceHero];
			//			for (NSDictionary* skill in [self.hero valueForKeyPath:@"skills.passive"])
			//				[D3CEHelper addSkillFromDictionary:skill toHero:d3ceHero];
		}
	}];
	
	[operation setCompletionBlockInCurrentThread:^{
		completion(aParty, gears);
	}];
	
	[[EUOperationQueue sharedQueue] addOperation:operation];
}

- (IBAction)onChangeHero:(id)sender {
	BOOL activeCompareHero = [sender selectedSegmentIndex] == 1;
	self.gearViewController.activeCompareHero = activeCompareHero;
	self.attributesViewController.hero = activeCompareHero ? self.compareHero : self.hero;
	self.attributesViewController.d3ceHero = activeCompareHero ? compareParty->getHeroes().front() : party->getHeroes().front();
	self.skillsViewController.hero = activeCompareHero ? self.compareHero : self.hero;
}

@end
