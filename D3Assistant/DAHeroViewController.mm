//
//  DAHeroViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAHeroViewController.h"
#import "D3APISession.h"
#import "DAStorage.h"
#import "DATaskManager.h"
#import "DAHeroGearViewController.h"
#import "DAHeroStatsViewController.h"
#import "DAHeroSkillsViewController.h"
#import "D3CEHelper.h"
#import "NSProgress+DA.h"

@interface DAHeroViewController ()
@property (assign, nonatomic) std::shared_ptr<d3ce::Engine> engine;
@property (assign, nonatomic) std::shared_ptr<d3ce::Party> party;
@property (assign, nonatomic) std::shared_ptr<d3ce::Hero> d3ceHero;
@property (strong, nonatomic) DATaskManager* taskManager;
- (void) loadGear;
- (void) setupControllers;
@end

@implementation DAHeroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[self.segmentedControl removeAllSegments];
		[self.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"Gear", 0) atIndex:0 animated:NO];
		[self.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"Stats/Skills", 0) atIndex:1 animated:NO];
		self.segmentedControl.selectedSegmentIndex = 0;
	}
	self.segmentedControl.hidden = self.hero == nil;
	self.scrollView.userInteractionEnabled = self.hero != nil;
	
	self.taskManager = [[DATaskManager alloc] initWithViewController:self];

	[self setupControllers];

	if (self.hero) {
		if (!self.hero.lastUpdated || [[self.hero lastUpdated] timeIntervalSinceNow] < - DAProfileUpdateTimeInterval) {
			NSString* battleTag = self.hero.profile.battleTag;
			int32_t heroID = self.hero.identifier;
			__block NSError* error;
			__block NSDictionary* hero;
			NSProgress* progress = [NSProgress startProgressWithTotalUnitCount:1];
			[[self taskManager] addTaskWithIndentifier:DATaskManagerIdentifierAuto
												 title:DATaskManagerDefaultTitle
												 block:^(DATask *task) {
													 hero = [[D3APISession sharedSession] heroProfileWithBattleTag:battleTag heroID:heroID error:&error];
												 }
									 completionHandler:^(DATask *task) {
										 progress.completedUnitCount = 1;
										 if (hero) {
											 [self.hero updateWithDictionary:hero];
											 [self.hero.managedObjectContext save:nil];
											 [self setupControllers];
											 [self loadGear];
										 }
										 else {
											 UIAlertController* controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
																												 message:[error localizedDescription]
																										  preferredStyle:UIAlertControllerStyleAlert];
											 [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil)
																							style:UIAlertActionStyleDefault
																						  handler:^(UIAlertAction *action) {
																							  [controller dismissViewControllerAnimated:YES completion:nil];
																						  }]];
											 [self presentViewController:controller animated:YES completion:nil];
										 }
									 }];
		}
		else {
			[self loadGear];
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChangeValue:(id)sender {
	[self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * [sender selectedSegmentIndex], self.scrollView.contentOffset.y) animated:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	NSInteger page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;

	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		self.scrollView.contentOffset = CGPointMake(page * self.scrollView.frame.size.width, self.scrollView.contentOffset.y);
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		self.scrollView.contentOffset = CGPointMake(page * self.scrollView.frame.size.width, self.scrollView.contentOffset.y);
	}];
}

#pragma mark - Navigation

- (IBAction)unwindFromItemInfo:(id)sender {
	
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		NSInteger page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
		if (self.segmentedControl.selectedSegmentIndex != page && page >= 0 && page < self.segmentedControl.numberOfSegments)
			[self.segmentedControl setSelectedSegmentIndex:page];
	}
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSInteger page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
	if (self.segmentedControl.selectedSegmentIndex != page && page >= 0 && page < self.segmentedControl.numberOfSegments)
		[self.segmentedControl setSelectedSegmentIndex:page];
}

#pragma mark - Private

- (void) loadGear {
	NSProgress* progress = [NSProgress startProgressWithTotalUnitCount:1];
	NSOperationQueue* queue = [NSOperationQueue new];
	NSOperation* finishOperation = [NSBlockOperation blockOperationWithBlock:^{
		@autoreleasepool {
			dispatch_async(dispatch_get_main_queue(), ^{
				if ([self.hero.managedObjectContext hasChanges])
					[self.hero.managedObjectContext save:nil];
				
				self.engine = [D3CEHelper sharedEngine];
				self.party = std::shared_ptr<d3ce::Party>(new d3ce::Party(self.engine));
				self.d3ceHero = [D3CEHelper addHero:self.hero toParty:self.party];
				progress.completedUnitCount = 1;
				
				for (id controller in self.childViewControllers) {
					if ([controller isKindOfClass:[DAHeroStatsViewController class]]) {
						DAHeroStatsViewController* statsController = (DAHeroStatsViewController*) controller;
						statsController.hero = self.d3ceHero;
					}
				}
			});
		}
	}];
	
	for (DAGear* gear in self.hero.defaultEquipment.gear) {
		if (!gear.item.itemInfo) {
			NSOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
				@autoreleasepool {
					NSDictionary* dic = [[D3APISession sharedSession] itemInfoWithItemID:gear.item.tooltipParams error:nil];
					if (dic) {
						dispatch_async(dispatch_get_main_queue(), ^{
							gear.item.itemInfo = [[DAItemInfo alloc] initWithDictionary:dic insertIntoManagedObjectContext:gear.item.managedObjectContext];
						});
					}
				}
			}];
			[finishOperation addDependency:operation];
			[queue addOperation:operation];
		}
	}
	[queue addOperation:finishOperation];
}

- (void) setupControllers {
	for (id controller in self.childViewControllers) {
		if ([controller isKindOfClass:[DAHeroGearViewController class]]) {
			DAHeroGearViewController* heroController = controller;
			heroController.hero = self.hero;
		}
		else if ([controller isKindOfClass:[DAHeroStatsViewController class]]) {
			DAHeroStatsViewController* statsController = controller;
			statsController.hero = self.d3ceHero;
		}
		else if ([controller isKindOfClass:[DAHeroSkillsViewController class]]) {
			DAHeroSkillsViewController* skillsController = controller;
			skillsController.hero = self.hero;
		}
	}
	
}

@end
