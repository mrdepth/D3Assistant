//
//  ProfilesViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 04.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ProfilesViewController.h"
#import "EUOperationQueue.h"
#import "D3APISession.h"
#import "HeroCellView.h"
#import "UITableViewCell+Nib.h"
#import "UIView+Nib.h"
#import "ProgressionView.h"
#import "CareerCellView.h"
#import "AppDelegate.h"
#import "NSDictionary+DeepMutableCopy.h"
#import "HeroViewController.h"
#import "UIAlertView+Error.h"
#import "RealmsViewController.h"
#import "UIActionSheet+Block.h"
#import "AppDelegate.h"

@interface ProfilesViewController ()
@property (nonatomic, strong) NSMutableArray* searchResults;
@property (nonatomic, strong) NSMutableArray* profiles;

- (IBAction)onRealm:(id)sender;
- (IBAction)onDonate:(id)sender;
- (void) didChangeRealm:(NSNotification*) notification;
- (void) reload;
- (NSString*) profilesFilePath;

@end

@implementation ProfilesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Profiles";
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Donate" style:UIBarButtonItemStyleBordered target:self action:@selector(onDonate:)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeRealm:) name:DidChangeRealmNotification object:nil];

	if (![[NSUserDefaults standardUserDefaults] valueForKey:@"realm"]) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Region" style:UIBarButtonItemStyleBordered target:self action:@selector(onRealm:)];
		RealmsViewController* controller = [[RealmsViewController alloc] initWithNibName:@"RealmsViewController" bundle:nil];
		UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
		navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[self presentModalViewController:navController animated:NO];
	}
	else {
		[self reload];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
	self.profiles = nil;
	self.searchResults = nil;
	[self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	else
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableView == self.searchDisplayController.searchResultsTableView ? (self.searchResults ? [self.searchResults count] : 0) : self.profiles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSDictionary* profile = tableView == self.searchDisplayController.searchResultsTableView ? [self.searchResults objectAtIndex:section] : [self.profiles objectAtIndex:section];
	return [[profile valueForKey:@"heroes"] count] + [[profile valueForKey:@"fallenHeroes"] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		static NSString *CellIdentifier = @"CareerCellView";
		CareerCellView *cell = (CareerCellView*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [CareerCellView cellWithNibName:@"CareerCellView" bundle:nil reuseIdentifier:CellIdentifier];
		NSDictionary* profile = tableView == self.searchDisplayController.searchResultsTableView ? [self.searchResults objectAtIndex:indexPath.section] : [self.profiles objectAtIndex:indexPath.section];
		cell.progressionHCView.hardcore = YES;

		cell.progressionSCView.progression = [D3Utility progressionWithProfile:profile hardcore:NO];
		cell.progressionHCView.progression = [D3Utility progressionWithProfile:profile hardcore:YES];
		return cell;
	}
	else {
		static NSString *CellIdentifier = @"HeroCellView";
		HeroCellView *cell = (HeroCellView*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [HeroCellView cellWithNibName:@"HeroCellView" bundle:nil reuseIdentifier:CellIdentifier];
		NSDictionary* profile = tableView == self.searchDisplayController.searchResultsTableView ? [self.searchResults objectAtIndex:indexPath.section] : [self.profiles objectAtIndex:indexPath.section];
		NSArray* array = [profile valueForKey:@"heroes"];
		NSInteger count = [array count];
		
		NSDictionary* hero;
		BOOL dead;
		if (indexPath.row - 1 >= count) {
			hero = [[profile valueForKey:@"fallenHeroes"] objectAtIndex:indexPath.row - 1 - count];
			dead = YES;
		}
		else {
			hero = [[profile valueForKey:@"heroes"] objectAtIndex:indexPath.row - 1];
			dead = NO;
		}
		
		BOOL hardcore = [[hero valueForKey:@"hardcore"] boolValue];
		cell.hardcore = hardcore;
		
		for (UILabel* label in cell.nameLabels)
			label.text = [hero valueForKey:@"name"];

		NSString* level = [NSString stringWithFormat:@"%d", [[hero valueForKey:@"level"] integerValue]];
		for (UILabel* label in cell.levelLabels)
			label.text = level;

		cell.paragonLevelLabel.text = [NSString stringWithFormat:@"%d", [[hero valueForKey:@"paragonLevel"] integerValue]];
		cell.classLabel.text = [[hero valueForKey:@"class"] capitalizedString];
		
		cell.avatarImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png", [hero valueForKey:@"class"], [hero valueForKey:@"gender"]]];
		cell.deadLabel.hidden = !dead;
		cell.skullImageView.hidden = !dead;
		return cell;
	}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	ProfileHeaderView* view = [ProfileHeaderView viewWithNibName:@"ProfileHeaderView" bundle:nil];
	NSDictionary* profile = tableView == self.searchDisplayController.searchResultsTableView ? [self.searchResults objectAtIndex:section] : [self.profiles objectAtIndex:section];
	NSString* battleTag = [profile valueForKey:@"battleTag"];
	view.profile = profile;
	view.battleTagLabel.text = battleTag;
	view.delegate = self;
	view.favoritesButton.selected = [[profile valueForKey:@"inFavorites"] boolValue];
	
	return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row == 0 ? 65 : 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row > 0) {
		NSDictionary* profile = tableView == self.searchDisplayController.searchResultsTableView ? [self.searchResults objectAtIndex:indexPath.section] : [self.profiles objectAtIndex:indexPath.section];
		NSArray* array = [profile valueForKey:@"heroes"];
		NSInteger count = [array count];
		
		NSDictionary* hero;
		BOOL fallen;
		if (indexPath.row - 1 >= count) {
			hero = [[profile valueForKey:@"fallenHeroes"] objectAtIndex:indexPath.row - 1 - count];
			fallen = YES;
		}
		else {
			hero = [[profile valueForKey:@"heroes"] objectAtIndex:indexPath.row - 1];
			fallen = NO;
		}
		
		if (fallen) {
			if (self.heroViewController) {
				self.heroViewController.fallen = fallen;
				self.heroViewController.hero = hero;
			}
			else {
				HeroViewController* controller = [[HeroViewController alloc] initWithNibName:@"HeroViewController" bundle:nil];
				controller.fallen = fallen;
				controller.hero = hero;
				[self.navigationController pushViewController:controller animated:YES];
			}
		}
		else {
			__block __unsafe_unretained EUOperation* operation = [EUOperation operationWithIdentifier:@"ProfilesViewController+LoadingHero" name:@"Loading Hero"];
			
			__block NSError* error = nil;
			__block NSDictionary* heroDetails = nil;
			
			[operation addExecutionBlock:^{
				@autoreleasepool {
					D3APISession* session = [D3APISession sharedSession];
					heroDetails = [session heroProfileWithBattleTag:[profile valueForKey:@"battleTag"] heroID:[[hero valueForKey:@"id"] integerValue] error:&error];
					operation.progress = 1;
				}
			}];
			
			[operation setCompletionBlockInCurrentThread:^{
				if (![operation isCancelled]) {
					if (error)
						[[UIAlertView alertViewWithError:error] show];
					else {
						if (self.heroViewController) {
							self.heroViewController.fallen = fallen;
							self.heroViewController.hero = heroDetails;
						}
						else {
							HeroViewController* controller = [[HeroViewController alloc] initWithNibName:@"HeroViewController" bundle:nil];
							controller.fallen = fallen;
							controller.hero = heroDetails;
							[self.navigationController pushViewController:controller animated:YES];
						}
					}
				}
			}];
			
			[[EUOperationQueue sharedQueue] addOperation:operation];
		}
	}
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString* text = searchBar.text;
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"battleTag like[c] %@", [text validBattleTagString]];
	NSArray* array = [self.profiles filteredArrayUsingPredicate:predicate];
	if (array.count > 0) {
		self.searchResults = [NSMutableArray arrayWithArray:array];
		[self.searchDisplayController.searchResultsTableView reloadData];
	}
	else {
		__block __unsafe_unretained EUOperation* operation = [EUOperation operationWithIdentifier:@"ProfilesViewController+Search" name:@"Searching"];
		
		__block NSError* error = nil;
		__block NSDictionary* resultTmp = nil;
		
		[operation addExecutionBlock:^{
			@autoreleasepool {
				D3APISession* session = [D3APISession sharedSession];
				resultTmp = [session careerProfileWithBattleTag:text error:&error];
				operation.progress = 1;
			}
		}];
		
		[operation setCompletionBlockInCurrentThread:^{
			if (![operation isCancelled]) {
				if (resultTmp) {
					self.searchResults = nil;
					NSString* battleTag = [resultTmp valueForKey:@"battleTag"];
					for (NSMutableDictionary* profile in self.profiles) {
						if ([[profile valueForKey:@"battleTag"] isEqualToString:battleTag]) {
							self.searchResults = [NSMutableArray arrayWithObject:profile];
							break;
						}
					}
					if (!self.searchResults) {
						self.searchResults = [NSMutableArray arrayWithObject:[resultTmp deepMutableCopy]];

						NSArray* sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hardcore" ascending:YES],
						[NSSortDescriptor sortDescriptorWithKey:@"level" ascending:NO],
						[NSSortDescriptor sortDescriptorWithKey:@"paragonLevel" ascending:NO],
						[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
						[[[self.searchResults objectAtIndex:0] valueForKey:@"heroes"] sortUsingDescriptors:sortDescriptors];
						[[[self.searchResults objectAtIndex:0] valueForKey:@"fallenHeroes"] sortUsingDescriptors:sortDescriptors];
					}
				}
				[self.searchDisplayController.searchResultsTableView reloadData];
			}
		}];
		
		[[EUOperationQueue sharedQueue] addOperation:operation];
	}
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"battleTag CONTAINS[c] %@", [searchString validBattleTagString]];
	self.searchResults = [NSMutableArray arrayWithArray:[self.profiles filteredArrayUsingPredicate:predicate]];
	return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)aTableView {
	aTableView.backgroundColor = [UIColor clearColor];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		aTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
		aTableView.backgroundView.contentMode = UIViewContentModeTopLeft;
	}
	else
		aTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
	[self.tableView reloadData];
}

#pragma mark - ProfileHeaderViewDelegate

- (void) profileHeaderViewDidPressFavoritesButton:(ProfileHeaderView*) profileHeaderView {
	NSString* battleTag = [profileHeaderView.profile valueForKey:@"battleTag"];
	
	if ([[profileHeaderView.profile valueForKey:@"inFavorites"] boolValue]) {
		NSInteger i = 0;
		[profileHeaderView.profile setValue:@(NO) forKey:@"inFavorites"];
		profileHeaderView.favoritesButton.selected = NO;
		for (NSDictionary* profile in self.profiles) {
			if ([[profile valueForKey:@"battleTag"] isEqualToString:battleTag]) {
				[self.profiles removeObjectAtIndex:i];
				[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
				break;
			}
			i++;
		}
	}
	else {
		NSInteger i = 0;
		for (NSDictionary* profile in self.profiles) {
			if ([[profile valueForKey:@"battleTag"] compare:battleTag options:NSCaseInsensitivePredicateOption] == NSOrderedDescending) {
				break;
			}
			i++;
		}
		[profileHeaderView.profile setValue:@(YES) forKey:@"inFavorites"];
		[self.profiles insertObject:profileHeaderView.profile atIndex:i];
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
		profileHeaderView.favoritesButton.selected = YES;
	}

	[self.profiles writeToFile:[self profilesFilePath] atomically:YES];
}

#pragma mark - Private

- (IBAction)onRealm:(id)sender {
	RealmsViewController* controller = [[RealmsViewController alloc] initWithNibName:@"RealmsViewController" bundle:nil];
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self presentModalViewController:navController animated:YES];
}

- (IBAction)onDonate:(id)sender {
	[[UIActionSheet actionSheetWithTitle:@"Donation"
					  cancelButtonTitle:@"Cancel"
				 destructiveButtonTitle:nil
					  otherButtonTitles:@[@"Donate $1", @"Donate $5", @"Donate $10"]
						completionBlock:^(UIActionSheet *actionSheet, NSInteger selectedButtonIndex) {
							if (selectedButtonIndex != actionSheet.cancelButtonIndex) {
								AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
								if (selectedButtonIndex == 0)
									[delegate donate:@"com.shimanski.d3assistant.donate1"];
								else if (selectedButtonIndex == 1)
									[delegate donate:@"com.shimanski.d3assistant.donate5"];
								else if (selectedButtonIndex == 2)
									[delegate donate:@"com.shimanski.d3assistant.donate10"];
							}
						} cancelBlock:nil] showFromBarButtonItem:sender animated:YES];
}

- (void) didChangeRealm:(NSNotification*) notification {
	self.searchResults = nil;
	self.profiles = nil;
	[self.tableView reloadData];
	[self.searchDisplayController.searchResultsTableView reloadData];
	[self reload];
}

- (void) reload {
	NSDictionary* realm = [[NSUserDefaults standardUserDefaults] valueForKey:@"realm"];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[realm valueForKey:@"name"] style:UIBarButtonItemStyleBordered target:self action:@selector(onRealm:)];
	[D3APISession setSharedSession:[[D3APISession alloc] initWithHost:[realm valueForKey:@"url"] locale:[[NSLocale preferredLanguages] objectAtIndex:0]]];
	
	self.profiles = [NSMutableArray arrayWithContentsOfFile:[self profilesFilePath]];
	if (self.profiles) {
		NSArray* profilesCopy = [NSArray arrayWithArray:self.profiles];
		__block __unsafe_unretained EUOperation* operation = [EUOperation operationWithIdentifier:@"ProfilesViewController+Update" name:@"Updating"];
		
		NSMutableArray* profilesTmp = [NSMutableArray array];
		
		[operation addExecutionBlock:^{
			@autoreleasepool {
				operation.progress = 0;
				D3APISession* session = [D3APISession sharedSession];
				
				NSInteger n = profilesCopy.count;
				NSInteger i = 0;
				for (NSMutableDictionary* profile in profilesCopy) {
					NSDictionary* result = [session careerProfileWithBattleTag:[profile valueForKey:@"battleTag"] error:nil];
					if (result) {
						NSMutableDictionary* profileTmp = [result deepMutableCopy];
						[profileTmp setValue:@(YES) forKey:@"inFavorites"];

						NSArray* sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hardcore" ascending:YES],
						[NSSortDescriptor sortDescriptorWithKey:@"level" ascending:NO],
						[NSSortDescriptor sortDescriptorWithKey:@"paragonLevel" ascending:NO],
						[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
						
						[[profileTmp valueForKey:@"heroes"] sortUsingDescriptors:sortDescriptors];
						[[profileTmp valueForKey:@"fallenHeroes"] sortUsingDescriptors:sortDescriptors];
						[profilesTmp addObject:profileTmp];
					}
					else
						[profilesTmp addObject:profile];
					
					operation.progress = (float) ++i / (float) n;
				}
			}
		}];
		
		[operation setCompletionBlockInCurrentThread:^{
			if (![operation isCancelled]) {
				self.profiles = profilesTmp;
				[self.searchDisplayController.searchResultsTableView reloadData];
				[self.tableView reloadData];
				[self.profiles writeToFile:[self profilesFilePath] atomically:YES];
			}
		}];
		
		[[EUOperationQueue sharedQueue] addOperation:operation];
	}
	else {
		self.profiles = [NSMutableArray array];
	}
}

- (NSString*) profilesFilePath {
	NSDictionary* realm = [[NSUserDefaults standardUserDefaults] valueForKey:@"realm"];
	return [[AppDelegate documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"profiles%@.plist", [realm valueForKey:@"name"]]];
}

@end
