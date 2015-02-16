//
//  DAProfilesTableViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 16.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAProfilesTableViewController.h"
#import "D3APISession.h"
#import "DATaskManager.h"
#import "DAStorage.h"
#import "DAProfileCell.h"
#import "DAHeroesViewController.h"
#import "UIColor+DA.h"

@interface DAProfilesTableViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSOperationQueue* updateQueue;
- (void) didSave:(NSNotification*) notification;

@end

@implementation DAProfilesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	self.updateQueue = [NSOperationQueue new];
	self.updateQueue.maxConcurrentOperationCount = 1;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeRegion:) name:DADidChangeRegionNotification object:nil];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:DADidChangeRegionNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setResultsController:(NSFetchedResultsController *)resultsController {
	_resultsController = resultsController;
	resultsController.delegate = self;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"DAHeroesViewController"]) {
		DAHeroesViewController* controller = segue.destinationViewController;
		if ([sender isKindOfClass:[DAProfile class]])
			controller.profile = sender;
		else if ([sender isKindOfClass:[DAProfileCell class]])
			controller.profile = [sender object];
		
		controller.profile.lastSeen = [NSDate date];
		[controller.profile.managedObjectContext save:nil];
	}
}

- (void) didChangeRegion:(NSNotification*) notification {
	self.resultsController = nil;
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.resultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = self.resultsController.sections[section];
	return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DAProfile* profile = [self.resultsController objectAtIndexPath:indexPath];
	DAProfileCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	
	int32_t softcoreHeroes = 0;
	int32_t hardcoreHeroes = 0;
	int32_t seasonalSoftcoreHeroes = 0;
	int32_t seasonalHardcoreHeroes = 0;
	
	for (DAHero* hero in profile.heroes) {
		if (hero.seasonal) {
			if (hero.hardcore)
				seasonalHardcoreHeroes++;
			else
				seasonalSoftcoreHeroes++;
		}
		else {
			if (hero.hardcore)
				hardcoreHeroes++;
			else
				softcoreHeroes++;
		}
	}
	
	NSAttributedString* (^string)(NSString* format, int32_t heroes, int32_t level) = ^ (NSString* format, int32_t heroes, int32_t level) {
		NSString* levelString = [NSString stringWithFormat:@"(%d)", level];
		NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:format, heroes, levelString] attributes:nil];
		[attributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor paragonColor]} range:NSMakeRange(attributedString.length - levelString.length, levelString.length)];
		return attributedString;
	};
	
	NSMutableAttributedString* details = [NSMutableAttributedString new];
	BOOL first = YES;
	if (softcoreHeroes > 0 || profile.paragonLevel > 0) {
		[details appendAttributedString:string(NSLocalizedString(@"%d softcore heroes %@", nil), softcoreHeroes, profile.paragonLevel)];
		first = NO;
	}
	if (hardcoreHeroes > 0 || profile.paragonLevelHardcore > 0) {
		if (!first)
			[details appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
		else
			first = NO;
		[details appendAttributedString:string(NSLocalizedString(@"%d hardcore heroes %@", nil), hardcoreHeroes, profile.paragonLevelHardcore)];
	}
	if (seasonalSoftcoreHeroes > 0 || profile.paragonLevelSeason > 0) {
		if (!first)
			[details appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
		else
			first = NO;
		[details appendAttributedString:string(NSLocalizedString(@"%d seasonal softcore heroes %@", nil), seasonalSoftcoreHeroes, profile.paragonLevelSeason)];
	}
	if (seasonalHardcoreHeroes > 0 || profile.paragonLevelSeasonHardcore > 0) {
		if (!first)
			[details appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
		else
			first = NO;
		[details appendAttributedString:string(NSLocalizedString(@"%d seasonal hardcore heroes %@", nil), seasonalHardcoreHeroes, profile.paragonLevelSeasonHardcore)];
	}
	
	cell.battleTagLabel.text = profile.battleTag;
	cell.detailsLabel.attributedText = details;
	cell.object = profile;
	
	if (!profile.lastUpdated || [profile.lastUpdated timeIntervalSinceNow] < - DAProfileUpdateTimeInterval) {
		D3APISession* session = [D3APISession sharedSession];

		[self.updateQueue addOperationWithBlock:^{
			__block NSDate* lastUpdated;
			__block NSString* battleTag;
			[profile.managedObjectContext performBlockAndWait:^{
				lastUpdated = profile.lastUpdated;
				battleTag = profile.battleTag;
			}];
			if (!lastUpdated || [lastUpdated timeIntervalSinceNow] < - DAProfileUpdateTimeInterval) {
				NSDictionary* career = [session careerProfileWithBattleTag:battleTag error:nil];
				if (career)
					dispatch_async(dispatch_get_main_queue(), ^{
						[profile.managedObjectContext performBlockAndWait:^{
							[profile updateWithDictionary:career];
							if ([profile.managedObjectContext hasChanges])
								[profile.managedObjectContext save:nil];
						}];
					});
			}
		}];
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return tableView.rowHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch (type) {
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
}

#pragma mark - Private

- (void) didSave:(NSNotification*) notification {
	for (id object in notification.userInfo[NSInsertedObjectsKey]) {
		if ([object isKindOfClass:[DAProfile class]]) {
			self.resultsController = nil;
			return;
		}
	}
}

@end
