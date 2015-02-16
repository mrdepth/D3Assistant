//
//  DAProfilesViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 10.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAProfilesViewController.h"
#import "D3APISession.h"
#import "DAStorage.h"
#import "DAProfileCell.h"
#import "DAProfilesSearchResultsViewController.h"
#import "DAProfilesHeaderView.h"
#import "DABrowserViewController.h"

@interface DAProfilesViewController()<UISearchControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) DAProfilesSearchResultsViewController* searchResultsViewController;
@property (nonatomic, strong) UIViewController* browserViewController;

@property (nonatomic, strong) NSMutableDictionary* updates;

@end

@implementation DAProfilesViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	NSString* name = [D3APISession sharedSession].region.name;
	if (name)
		self.navigationItem.rightBarButtonItem.title = name;

	[self.tableView registerNib:[UINib nibWithNibName:@"DAProfilesHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"Header"];

	self.searchResultsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DAProfilesSearchResultsViewController"];
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsViewController];
	self.searchController.searchBar.barStyle = UIBarStyleBlackTranslucent;
	[self.searchController.searchBar sizeToFit];
	self.searchController.searchBar.showsBookmarkButton = YES;
	self.searchController.searchBar.delegate = self;
	self.searchController.searchBar.placeholder = NSLocalizedString(@"BattleTag#Code", nil);
	self.searchController.searchResultsUpdater = self.searchResultsViewController;
	self.searchController.delegate = self;
	self.tableView.tableHeaderView = self.searchController.searchBar;

	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.definesPresentationContext = YES;
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController*) resultsController {
	NSFetchedResultsController* resultsController = [super resultsController];
	if (!resultsController) {
		D3APISession* session = [D3APISession sharedSession];
		
		DAStorage* storage = [DAStorage sharedStorage];
		NSManagedObjectContext* managedObjectContext = storage.managedObjectContext;
		
		
		NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
		request.predicate = [NSPredicate predicateWithFormat:@"region = %@", session.region.identifier];
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"favorite" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"lastSeen" ascending:NO]];
		request.fetchBatchSize = 10;
		
		resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"favorite" cacheName:nil];
		[resultsController performFetch:nil];
		[super setResultsController:resultsController];
	}
	
	return resultsController;
}

- (IBAction)onRegion:(id)sender {
	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose your region", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
	for (D3APIRegion* region in [D3APIRegion allRegions]) {
		UIAlertAction* action = [UIAlertAction actionWithTitle:region.name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			D3APISession* session = [[D3APISession alloc] initWithRegion:region locale:[NSLocale preferredLanguages][0]];
			[D3APISession setSharedSession:session];
			[[NSUserDefaults standardUserDefaults] setValue:region.identifier forKey:DASettingsRegionKey];
		}];
		[alertController addAction:action];
	}
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void) didChangeRegion:(NSNotification*) notification {
	[super didChangeRegion:notification];
	self.navigationItem.rightBarButtonItem.title = [D3APISession sharedSession].region.name;
}

#pragma mark - Navigation

- (IBAction)unwindFromBrowserWithSegue:(UIStoryboardSegue*) segue {
	DABrowserViewController* controller = segue.sourceViewController;
	if (controller.profile) {
		[controller dismissViewControllerAnimated:YES completion:^{
			dispatch_async(dispatch_get_main_queue(), ^{
				[self performSegueWithIdentifier:@"DAHeroesViewController" sender:controller.profile];
			});
		}];
	}
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	[self performSegueWithIdentifier:@"DAHeroesViewController" sender:cell];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (NSArray*) tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	DAProfile* profile = [self.resultsController objectAtIndexPath:indexPath];
	
	UITableViewRowAction* favorite;
	if (profile.favorite)
		favorite = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Unfavorite" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
			DAProfile* profile = [self.resultsController objectAtIndexPath:indexPath];
			profile.favorite = NO;
			[profile.managedObjectContext save:nil];
		}];
	else
		favorite = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Favorite" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
			DAProfile* profile = [self.resultsController objectAtIndexPath:indexPath];
			profile.favorite = YES;
			[profile.managedObjectContext save:nil];
		}];
	
	
	UITableViewRowAction* remove = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
		DAProfile* profile = [self.resultsController objectAtIndexPath:indexPath];
		NSManagedObjectContext* context = profile.managedObjectContext;
		[context deleteObject:profile];
		[context save:nil];
	}];
	
	return @[remove, favorite];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([[(id<NSFetchedResultsSectionInfo>)self.resultsController.sections[section] name] isEqualToString:@"0"])
		return NSLocalizedString(@"Last Seen", nil);
	else
		return NSLocalizedString(@"Favorites", nil);
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	DAProfilesHeaderView* header = (DAProfilesHeaderView*) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
	header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	return header;
}

#pragma mark - UISearchControllerDelegate

- (void)willDismissSearchController:(UISearchController *)searchController {
	if (![super resultsController])
		[self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
	if (!self.browserViewController) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
			self.browserViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DABrowserViewController"];
		else {
			UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DABrowserViewController"]];
			navigationController.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
			navigationController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
			navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
			self.browserViewController = navigationController;
		}
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		[self.navigationController pushViewController:self.browserViewController animated:YES];
	else
		[self presentViewController:self.browserViewController animated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchResultsViewController search];
}

@end
