//
//  ProfilesViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 04.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ProfilesViewController.h"
#import "EUOperationQueue.h"
#import "DiabloAPISession.h"
#import "HeroCellView.h"
#import "UITableViewCell+Nib.h"
#import "UIView+Nib.h"
#import "ProgressionView.h"
#import "CareerCellView.h"

@interface ProfilesViewController ()
@property (nonatomic, strong) NSString* host;
@property (nonatomic, strong) NSMutableArray* searchResults;
@property (nonatomic, strong) NSMutableArray* profiles;
@end

@implementation ProfilesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	self.profiles = [NSMutableArray array];
	self.host = @"http://eu.battle.net";
	
//	ProgressionView* v = [[ProgressionView alloc] initWithFrame:CGRectMake(10, 10, 290, 27)];
//	v.progression = 0.5;
//	[self.view addSubview:v];
}

- (void)viewDidUnload
{
	[self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
		
		for (UILabel* label in cell.nameLabels) {
			label.text = [hero valueForKey:@"name"];
			label.textColor = hardcore ? [UIColor redColor] : cell.levelLabel.textColor;
		}
		
		cell.frameImageView.image = [UIImage imageNamed:hardcore ? @"frameHeroHC.png" : @"frameHeroSC.png"];
		
		cell.levelLabel.text = [NSString stringWithFormat:@"%@", [hero valueForKey:@"level"]];
		cell.paragonLevelLabel.text = [NSString stringWithFormat:@"%@", [hero valueForKey:@"paragonLevel"]];
		cell.classLabel.text = [NSString stringWithFormat:@"%@ %@", [[hero valueForKey:@"class"] capitalizedString], hardcore ? @"(Hardcore)" : @""];
		
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
		__block __weak EUOperation* operation = [EUOperation operationWithIdentifier:@"Search" name:@"Searching"];
		
		__block NSError* error = nil;
		__block NSDictionary* resultTmp = nil;
		
		[operation addExecutionBlock:^{
			@autoreleasepool {
				DiabloAPISession* session = [[DiabloAPISession alloc] initWithHost:self.host locale:[[NSLocale currentLocale] localeIdentifier]];
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
						self.searchResults = [NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:resultTmp]];
						NSArray* sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hardcore" ascending:YES],
						[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
						];
						[[[self.searchResults objectAtIndex:0] valueForKey:@"heroes"] sortUsingDescriptors:sortDescriptors];
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
}

@end
