//
//  DAProfilesSearchResultsViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 16.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAProfilesSearchResultsViewController.h"
#import "D3APISession.h"
#import "DAStorage.h"
#import "DATaskManager.h"
#import "NSProgress+DA.h"

@interface DAProfilesSearchResultsViewController ()
@property (nonatomic, strong) NSString* searchString;
@property (nonatomic, strong) DATaskManager* taskManager;

- (void) search;
- (void) update;

@end

@implementation DAProfilesSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.taskManager = [[DATaskManager alloc] initWithViewController:self];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController*) resultsController {
	NSFetchedResultsController* resultsController = [super resultsController];

	if (!resultsController) {
		NSString* string = self.searchString;
		NSString* battleTag = [string validBattleTagString];
		if (battleTag)
			string = battleTag;
		if (string.length < 1)
			return nil;
		
		D3APISession* session = [D3APISession sharedSession];
		
		NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
		request.predicate = [NSPredicate predicateWithFormat:@"region = %@ AND battleTag BEGINSWITH[c] %@", session.region.identifier, string];
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"favorite" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"lastSeen" ascending:NO]];
		request.fetchBatchSize = 10;
		
		DAStorage* storage = [DAStorage sharedStorage];
		NSManagedObjectContext* managedObjectContext = storage.managedObjectContext;
		
		resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"favorite" cacheName:nil];
		[resultsController performFetch:nil];
		[super setResultsController:resultsController];
	}
	
	return resultsController;
}

- (void) search {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	NSString* battleTag = [self.searchString validBattleTagString];
	
	
	if (battleTag) {
		D3APISession* session = [D3APISession sharedSession];
		
		DAStorage* storage = [DAStorage sharedStorage];
		NSManagedObjectContext* managedObjectContext = storage.managedObjectContext;
		
		DAProfile* profile = [DAProfile profileWithRegion:session.region.identifier battleTag:battleTag];
		if (profile)
			[self update];
		else {
			__block NSError* error = nil;
			__block NSDictionary* career;
			NSProgress* progress = [NSProgress startProgressWithTotalUnitCount:1];
			[[self taskManager] addTaskWithIndentifier:DATaskManagerIdentifierAuto
												 title:DATaskManagerDefaultTitle
												 block:^(DATask *task) {
													 career = [session careerProfileWithBattleTag:battleTag error:&error];
												 }
									 completionHandler:^(DATask *task) {
										 progress.completedUnitCount = 1;
										 if (career) {
											 DAProfile* profile = [[DAProfile alloc] initWithRegion:session.region.identifier dictionary:career insertIntoManagedObjectContext:managedObjectContext];
											 profile.lastSeen = [NSDate date];
											 NSError* error = nil;
											 [managedObjectContext save:&error];
											 [self update];
										 }
										 else {
											 [self update];
										 }
									 }];
		}
	}
	[self update];
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	[self.presentingViewController performSegueWithIdentifier:@"DAHeroesViewController" sender:cell];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.searchString = searchController.searchBar.text;
	[self performSelector:@selector(search) withObject:nil afterDelay:2];
	[self update];
}

#pragma mark - Private

- (void) update {
	self.resultsController = nil;
	[NSObject cancelPreviousPerformRequestsWithTarget:self.tableView selector:@selector(reloadData) object:nil];
	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
}

@end
