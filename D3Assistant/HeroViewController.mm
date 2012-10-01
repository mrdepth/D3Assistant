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
@end

@implementation HeroViewController {
	d3ce::Engine* engine;
	d3ce::Party* party;
	d3ce::Hero* d3ceHero;
}
@synthesize sectionsControl;
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

- (void) dealloc {
	delete engine;
	delete party;
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

- (void) setHero:(NSDictionary *)aHero fallen:(BOOL) isFallen {
	hero = aHero;
	fallen = isFallen;
	
	if ([self isViewLoaded])
		[self reload];
}

#pragma mark - Private

- (void) reload {
	[self.attributesViewController setHero:self.hero fallen:self.fallen];
	[self.gearViewController setHero:self.hero fallen:self.fallen];
	[self.skillsViewController setHero:self.hero];
	
	if (!self.hero) {
		[self.navigationItem setLeftBarButtonItem:nil animated:YES];
		self.title = @"";
	}
	else
		self.title = [self.hero valueForKey:@"name"];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (fallen) {
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
		if (fallen)
			[self.sectionsControl removeSegmentAtIndex:2 animated:NO];
	}
	
	__block __weak EUOperation* operation = [EUOperation operationWithIdentifier:@"HeroViewController+Load" name:@"Loading"];
	
	NSMutableDictionary* gears = [NSMutableDictionary dictionary];
	if (!engine)
		engine = [D3CEHelper newEgine];
	if (party)
		delete party;
	party = new d3ce::Party(engine);
	d3ceHero = [D3CEHelper addHeroFromDictionary:self.hero toParty:party];
	
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
				if (d3ceHero)
					[D3CEHelper addItemFromDictionary:item toHero:d3ceHero slot:[D3CEHelper slotFromString:key] replaceExisting:NO];
				
				operation.progress = (float) ++i / (float) n;
			}
			
//			for (NSDictionary* skill in [self.hero valueForKeyPath:@"skills.active"])
//				[D3CEHelper addSkillFromDictionary:skill toHero:d3ceHero];
			for (NSDictionary* skill in [self.hero valueForKeyPath:@"skills.passive"])
				[D3CEHelper addSkillFromDictionary:skill toHero:d3ceHero];
		}
	}];
	
	[operation setCompletionBlockInCurrentThread:^{
		if (![operation isCancelled]) {
			self.gearViewController.gears = gears;
			self.gearViewController.party = party;
		}
	}];
	
	[[EUOperationQueue sharedQueue] addOperation:operation];

}

@end
